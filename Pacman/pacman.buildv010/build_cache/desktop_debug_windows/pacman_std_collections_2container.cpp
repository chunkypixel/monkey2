
#include "pacman_std_collections_2container.h"

// ***** External *****

// ***** Internal *****

bbString bbDBType(t_std_collections_IContainer_1Tt_pacman_Sprite_2**){
  return "std.collections.IContainer<pacman.Sprite>";
}
bbString bbDBValue(t_std_collections_IContainer_1Tt_pacman_Sprite_2**p){
  return bbDBInterfaceValue(*p);
}

void mx2_pacman_std_collections_2container_init(){
  static bool done;
  if(done) return;
  done=true;
}

bbInit mx2_pacman_std_collections_2container_init_v("pacman_std_collections_2container",&mx2_pacman_std_collections_2container_init);
