
#ifndef MX2_PACMAN_SRC_2GRID_H
#define MX2_PACMAN_SRC_2GRID_H

#include <bbmonkey.h>

// ***** External *****

struct t_pacman_ImageCollection;
bbString bbDBType(t_pacman_ImageCollection**);
bbString bbDBValue(t_pacman_ImageCollection**);
struct t_mojo_graphics_Canvas;
bbString bbDBType(t_mojo_graphics_Canvas**);
bbString bbDBValue(t_mojo_graphics_Canvas**);

// ***** Internal *****

extern bbInt g_pacman_GridWidth;
extern bbInt g_pacman_GridHeight;
extern bbInt g_pacman_Layers;
extern bbGCRootVar<bbArray<bbInt,3>> g_pacman_Grid;
extern bbGCRootVar<t_pacman_ImageCollection> g_pacman_Blocks;

extern void g_pacman_TransferToGrid(bbInt l_layer,bbArray<bbInt>* l_layout);
extern void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_InitialisePillGrid();
extern void g_pacman_InitialiseGrid();

#endif
