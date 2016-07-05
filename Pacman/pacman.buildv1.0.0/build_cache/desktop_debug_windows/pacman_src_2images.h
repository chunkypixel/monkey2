
#ifndef MX2_PACMAN_SRC_2IMAGES_H
#define MX2_PACMAN_SRC_2IMAGES_H

#include <bbmonkey.h>

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/monkey/monkey.buildv1.0.0/desktop_debug_windows/monkey_types.h"

struct t_mojo_graphics_Image;
bbString bbDBType(t_mojo_graphics_Image**);
bbString bbDBValue(t_mojo_graphics_Image**);

// ***** Internal *****

struct t_pacman_ImageCollection;

struct t_pacman_ImageCollection : public bbObject{

  const char *typeName()const{return "t_pacman_ImageCollection";}

  bbGCVar<bbArray<bbGCVar<t_mojo_graphics_Image>>> m__0images{};

  void gcMark();
  void dbEmit();

  t_pacman_ImageCollection(bbString l_imageName,bbInt l_width,bbInt l_height,bbInt l_textureFlags);

  bbArray<bbGCVar<t_mojo_graphics_Image>>* m_Item();
  bbInt m_Count();

  t_pacman_ImageCollection(){
  }
};
bbString bbDBType(t_pacman_ImageCollection**);
bbString bbDBValue(t_pacman_ImageCollection**);

#endif
