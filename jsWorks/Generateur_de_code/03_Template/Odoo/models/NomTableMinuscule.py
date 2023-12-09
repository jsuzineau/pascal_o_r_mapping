from odoo import api,fields, models, exceptions

class Nom_de_la_classe(models.Model):
    _name= "nommodule.NomTableMinuscule"
    _description = "Nom_de_la_classe"

models_class.py_field_creation_line

    #provisoirement dans le template comme exemple pour mise au point
    description       = fields.Text()
    date_availability = fields.Date(string="Available From")
    expected_price    = fields.Float(required=True,string="Expected Price")
    garden            = fields.Boolean()
    property_type_id= fields.Many2one("estate.property.type", string="Property type")
    tag_ids=fields.Many2many("estate.property.tag", string="Tags")
    offer_ids=fields.One2many("estate.property.offer", "property_id", string="Offers")

