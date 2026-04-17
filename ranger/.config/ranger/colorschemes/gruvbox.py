# Ranger colorscheme - Gruvbox-inspired 256-color mapping
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Gruvbox(ColorScheme):
    progress_bar_color = yellow

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors
        if context.in_browser:
            if context.selected:
                attr = reverse
            if context.empty or context.error:
                fg = red
            if context.border:
                fg = black
            if context.media:
                fg = magenta
            if context.container:
                fg = yellow
            if context.directory:
                fg = blue
                attr |= bold
            if context.executable and not any((context.media, context.container, context.fifo, context.socket)):
                fg = green
                attr |= bold
            if context.link:
                fg = cyan
            if context.bad:
                fg = red
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = yellow
        elif context.in_titlebar:
            attr |= bold
            fg = yellow
        elif context.in_statusbar:
            fg = white
            if context.permissions:
                if context.good:
                    fg = green
                elif context.bad:
                    fg = red
            if context.marked:
                attr |= bold
                fg = yellow
        elif context.text:
            fg = white
        return fg, bg, attr
