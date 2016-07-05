
#ifndef MX2_PACMAN_SRC_2GRID_H
#define MX2_PACMAN_SRC_2GRID_H

#include <bbmonkey.h>

// ***** External *****

struct t_pacman_ImageCollection;
struct t_mojo_graphics_Canvas;

// ***** Internal *****

extern bbInt g_pacman_GridWidth;
extern bbInt g_pacman_GridHeight;
extern bbGCRootVar<bbArray<bbInt,2>> g_pacman_Grid;
extern bbGCRootVar<t_pacman_ImageCollection> g_pacman_GridBlocks;

extern void g_pacman_TransferToGrid(bbArray<bbInt>* l_layout);
extern void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_InitialiseGrid();

#endif
