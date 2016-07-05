
#include "pacman_src_2grid.h"

// ***** External *****

// ***** Internal *****

bbGCRootVar<bbArray<bbInt,2>> g_pacman_Grid;

void g_pacman_InitialiseGrid(){
}

void mx2_pacman_src_2grid_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_Grid=bbArray<bbInt,2>::create(28,36);
}

bbInit mx2_pacman_src_2grid_init_v("pacman_src_2grid",&mx2_pacman_src_2grid_init);
