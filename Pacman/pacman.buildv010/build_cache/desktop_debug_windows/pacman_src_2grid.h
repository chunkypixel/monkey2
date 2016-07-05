
#ifndef MX2_PACMAN_SRC_2GRID_H
#define MX2_PACMAN_SRC_2GRID_H

#include <bbmonkey.h>

// ***** External *****

struct t_mojo_graphics_Canvas;
bbString bbDBType(t_mojo_graphics_Canvas**);
bbString bbDBValue(t_mojo_graphics_Canvas**);

// ***** Internal *****

extern bbGCRootVar<bbArray<bbInt,2>> g_pacman_Grid;

extern void g_pacman_TransferToGrid(bbArray<bbInt>* l_layout,bbInt l_width,bbInt l_height);
extern void g_pacman_TransferToGrid(bbArray<bbInt>* l_layout);
extern void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_InitialiseGrid();

#endif
