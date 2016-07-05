
#include "pacman_src_2images.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2image.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_release_windows/std_geom_2rect.h"

struct t_mojo_graphics_Shader;

// ***** Internal *****

void t_pacman_ImageCollection::gcMark(){
  bbGCMark(m__0images);
}

t_pacman_ImageCollection::t_pacman_ImageCollection(bbString l_imageName,bbInt l_width,bbInt l_height,bbInt l_textureFlags){
  struct f0_t : public bbGCFrame{
    t_mojo_graphics_Image* l_imageStrip{};
    void gcMark(){
      bbGCMarkPtr(l_imageStrip);
    }
  }f0{};
  f0.l_imageStrip=g_mojo_graphics_Image_Load(l_imageName,l_textureFlags,((t_mojo_graphics_Shader*)0));
  bbInt l_count=(f0.l_imageStrip->m_Width()/l_width);
  this->m__0images=bbArray<bbGCVar<t_mojo_graphics_Image>>::create(l_count);
  {
    bbInt l_index=bbInt(0);
    for(;(l_index<l_count);l_index+=1){
      struct f2_t : public bbGCFrame{
        t_mojo_graphics_Image* l_newImage{};
        void gcMark(){
          bbGCMarkPtr(l_newImage);
        }
      }f2{};
      bbInt l_x=(l_index*l_width);
      f2.l_newImage=bbGCNew<t_mojo_graphics_Image>(f0.l_imageStrip,t_std_geom_Rect_1i(l_x,bbInt(0),(l_x+l_width),l_height));
      this->m__0images->at(l_index)=f2.l_newImage;
    }
  }
}

bbArray<bbGCVar<t_mojo_graphics_Image>>* t_pacman_ImageCollection::m_Item(){
  return this->m__0images;
}

bbInt t_pacman_ImageCollection::m_Count(){
  return this->m__0images->length();
}

void mx2_pacman_src_2images_init(){
  static bool done;
  if(done) return;
  done=true;
}

bbInit mx2_pacman_src_2images_init_v("pacman_src_2images",&mx2_pacman_src_2images_init);
