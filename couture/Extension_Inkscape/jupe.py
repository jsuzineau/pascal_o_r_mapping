#!/usr/bin/env python
# -*- coding: utf-8 -*
#                                                                              |
#  Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
#          http://www.mars42.com                                               |
#                                                                              |
#  Copyright 2018 Jean SUZINEAU - MARS42                                       |
#                                                                              |
#  This program is free software: you can redistribute it and/or modify        |
#  it under the terms of the GNU Lesser General Public License as published by |
#  the Free Software Foundation, either version 3 of the License, or           |
#  (at your option) any later version.                                         |
#                                                                              |
#  This program is distributed in the hope that it will be useful,             |
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              |
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
#  GNU Lesser General Public License for more details.                         |
#                                                                              |
#  You should have received a copy of the GNU Lesser General Public License    |
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
#                                                                              |

import math
import os
import sys
#sys.path.append('/usr/share/inkscape/extensions')

import inkex
import simplestyle

class JupeEffect(inkex.Effect):
    def __init__(self):
        inkex.Effect.__init__(self)
        try:
            self.tty = open("/dev/tty", 'w')
        except:
            self.tty = open(os.devnull, 'w')  # '/dev/null' for POSIX, 'nul' for Windows.

        self.OptionParser.add_option('', '--hauteur_av'         , action = 'store', type = 'float', dest = 'hauteur_av'         , default = '0', help = '')
        self.OptionParser.add_option('', '--hauteur_ar'         , action = 'store', type = 'float', dest = 'hauteur_ar'         , default = '0', help = '')
        self.OptionParser.add_option('', '--ourlet_bas'         , action = 'store', type = 'float', dest = 'ourlet_bas'         , default = '0', help = '')
        self.OptionParser.add_option('', '--assemblage_ceinture', action = 'store', type = 'float', dest = 'assemblage_ceinture', default = '0', help = '')
        self.OptionParser.add_option('', '--rayon_disque'       , action = 'store', type = 'float', dest = 'rayon_disque'       , default = '0', help = '')
    def effect(self):
        hauteur_av         = self.options.hauteur_av
        hauteur_ar         = self.options.hauteur_ar
        ourlet_bas         = self.options.ourlet_bas
        assemblage_ceinture= self.options.assemblage_ceinture
        rayon_disque       = self.options.rayon_disque

        rayon_av     = rayon_disque+assemblage_ceinture+ourlet_bas+hauteur_av
        rayon_ar     = rayon_disque+assemblage_ceinture+ourlet_bas+hauteur_ar
        rayon_cote   = (rayon_av+rayon_ar)/2
        rayon_cote_av=(rayon_cote+rayon_av)/2
        rayon_cote_ar=(rayon_cote+rayon_ar)/2

        uu_rayon_disque = self.get_unittouu(str(rayon_disque )+'mm')
        uu_rayon_av     = self.get_unittouu(str(rayon_av     )+'mm')
        uu_rayon_ar     = self.get_unittouu(str(rayon_ar     )+'mm')
        uu_rayon_cote   = self.get_unittouu(str(rayon_cote   )+'mm')
        uu_rayon_cote_av= self.get_unittouu(str(rayon_cote_av)+'mm')
        uu_rayon_cote_ar= self.get_unittouu(str(rayon_cote_ar)+'mm')

        svg = self.document.getroot()
        #parent = self.current_layer
        parent=svg
        self.svg_text( parent, uu_rayon_cote_av-uu_rayon_disque/2, uu_rayon_av, 'AV')
        self.draw_SVG_ellipse(uu_rayon_disque ,uu_rayon_disque, uu_rayon_cote_av, uu_rayon_av, parent,math.pi/2  ,math.pi)
        self.draw_SVG_ellipse(uu_rayon_cote_av,uu_rayon_av    , uu_rayon_cote_av, uu_rayon_av, parent,3/2*math.pi,math.pi/2)
        self.draw_SVG_ellipse(uu_rayon_cote_av,uu_rayon_cote  , uu_rayon_cote_av, uu_rayon_av, parent,math.pi/2  ,math.pi/2)
        self.addline_x= uu_rayon_cote_av/4
        self.addline_y= uu_rayon_av+uu_rayon_disque
        self.addline_text_height=14
        self.addline( parent, 'hauteur_av...: %f'        %(hauteur_av                    ))
        self.addline( parent, 'hauteur_ar...: %f'        %(hauteur_ar                    ))
        self.addline( parent, 'rayon_av.....: %f, 2*: %f'%(rayon_av     , 2*rayon_av     ))
        self.addline( parent, 'rayon_ar.....: %f, 2*: %f'%(rayon_ar     , 2*rayon_ar     ))
        self.addline( parent, 'rayon_cote...: %f, 2*: %f'%(rayon_cote   , 2*rayon_cote   ))
        self.addline( parent, 'rayon_cote_av: %f, 2*: %f'%(rayon_cote_av, 2*rayon_cote_av))
        self.addline( parent, 'rayon_cote_ar: %f, 2*: %f'%(rayon_cote_ar, 2*rayon_cote_ar))
        #print >>self.tty,
    def get_unittouu(self, param):
        " for 0.48 and 0.91 compatibility "
        try:
            return inkex.unittouu(param)
        except AttributeError:
            return self.unittouu(param)
    def draw_SVG_ellipse(self, rx, ry, cx, cy, parent, _start=0.0, _length=2*math.pi, transform='' ):
        style = {   'stroke'        : '#000000',
                    'stroke-width'  : '1',
                    'fill'          : 'none'            }
        end= _start + _length
        ell_attribs = {'style':simplestyle.formatStyle(style),
            inkex.addNS('cx','sodipodi')        :str(cx),
            inkex.addNS('cy','sodipodi')        :str(cy),
            inkex.addNS('rx','sodipodi')        :str(rx),
            inkex.addNS('ry','sodipodi')        :str(ry),
            inkex.addNS('start','sodipodi')     :str(_start),
            inkex.addNS('end','sodipodi')       :str( end),
            inkex.addNS('open','sodipodi')      :'true',    #all ellipse sectors we will draw are open
            inkex.addNS('type','sodipodi')      :'arc',
            'transform'                         :transform
                }
        ell = inkex.etree.SubElement(parent, inkex.addNS('path','svg'), ell_attribs)
    def svg_text( self, _parent, _cx, _cy, _text):
        font_height = 24
        text_style = { 'font-size': str(font_height),
                       'font-family': 'arial',
                       'text-anchor': 'middle',
                       'text-align': 'center'#,
                       #'fill': path_stroke
                       }
        text_atts = {'style':simplestyle.formatStyle(text_style),
                     'x': str(_cx),
                     'y': str(_cy)}
        text = inkex.etree.SubElement(_parent, 'text', text_atts)
        text.text = _text
    def add_text(self, node, text, position, text_height=24):
        """ Create and insert a single line of text into the svg under node.
        """
        line_style = {'font-size': '%dpx' % text_height, 'font-style':'normal', 'font-weight': 'normal',
                     #'fill': '#F6921E',
                     'font-family': 'Courier New',
                     'text-anchor': 'left',
                     'text-align': 'left'
                     }
        line_attribs = {inkex.addNS('label','inkscape'): 'Annotation',
                       'style': simplestyle.formatStyle(line_style),
                       'x': str(position[0]),
                       'y': str(position[1] + text_height)
                       }
        line = inkex.etree.SubElement(node, inkex.addNS('text','svg'), line_attribs)
        line.text = text
    def addline( self, _parent, _text):
        self.add_text( _parent, _text, [self.addline_x,self.addline_y], self.addline_text_height)
        self.addline_y+= self.addline_text_height * 1.2


e=JupeEffect()
e.affect();

