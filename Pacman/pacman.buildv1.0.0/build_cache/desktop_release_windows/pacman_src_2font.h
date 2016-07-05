
#ifndef MX2_PACMAN_SRC_2FONT_H
#define MX2_PACMAN_SRC_2FONT_H

#include <bbmonkey.h>

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_release_windows/std_graphics_2color.h"

struct t_pacman_ImageCollection;
struct t_mojo_graphics_Canvas;

// ***** Internal *****

extern bbGCRootVar<t_pacman_ImageCollection> g_pacman__0font;
extern bbString g_pacman__0chars;

extern void g_pacman_DrawFont(t_mojo_graphics_Canvas* l_canvas,bbString l_text,bbInt l_x,bbInt l_y,t_std_graphics_Color l_color);
extern void g_pacman_InitialiseFont();

#endif
