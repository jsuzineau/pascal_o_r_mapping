from odoo import api,fields, models, exceptions

class Nom_de_la_classe(models.Model):
    _name= "nommodule.NomTableMinuscule"
    _description = "Nom_de_la_classe"

models_class.py_field_creation_line
    name              = fields.Char(required=True, string="Title")
    description       = fields.Text()
    postcode          = fields.Char()
    date_availability = fields.Date(string="Available From")
    expected_price    = fields.Float(required=True,string="Expected Price")
    selling_price     = fields.Float(string="Selling Price")
    bedrooms          = fields.Integer()
    living_area       = fields.Integer(string="Living area(sqm)")
    facades           = fields.Integer()
    garage            = fields.Boolean()

    garden            = fields.Boolean()
    @api.onchange("garden")
    def _onchange_garden(self):
        if self.garden:
            self.garden_area= 10
            self.garden_orientation=Property.garden_orientation.north
        else:
            self.garden_area= 0
            self.garden_orientation=None

    garden_area       = fields.Integer(string="Garden area(sqm)")
    garden_orientation= fields.Selection(
        string='Garden Orientation',
        selection=[
         ('north','North'),
         ('south','South'),
         ('east' ,'East' ),
         ('west' ,'West' )
         ],
        help="Type is used to define orientation")

    active= fields.Boolean(default=True)
    state= fields.Selection(
        string='Status',
        default='new',
        selection=[
            ('new'           ,'New           '),
            ('offer_received','Offer Received'),
            ('offer_accepted','Offer Accepted'),
            ('sold'          ,'Sold          '),
            ('canceled'      ,'Canceled      ')
            ],
        help="Type is used to define status")
    def action_Sold(self):
        for record in self:
            if "canceled" == record.state :
                raise exceptions.UserError("Canceled properties cannot be sold")
            else:
              record.state= "sold"
        return True
    def action_Canceled(self):
        for record in self:
            if "sold" == record.state :
                raise exceptions.UserError("Sold properties cannot be Canceled")
            else:
              record.state= "canceled"
        return True
    property_type_id= fields.Many2one("estate.property.type", string="Property type")
    salesman_id = fields.Many2one('res.users', index=True, tracking=True, default=lambda self: self.env.user)
    buyer_id=fields.Many2one('res.partner', index=True, tracking=True)
    tag_ids=fields.Many2many("estate.property.tag", string="Tags")
    offer_ids=fields.One2many("estate.property.offer", "property_id", string="Offers")

    #total_area
    @api.depends("living_area")
    @api.depends("garden_area")
    def _compute_total_area(self):
        for record in self:
            record.total_area = record.living_area+record.garden_area
    total_area = fields.Float(compute="_compute_total_area", string="Total Area(sqm)")

    #best_price
    @api.depends("offer_ids.price")
    def _compute_best_price(self):
        for record in self:
            if record.offer_ids:
                record.best_price = min(record.offer_ids.mapped('price'))
            else:
                record.best_price = ""
    best_price = fields.Float(compute="_compute_best_price", string="Best Offer")

