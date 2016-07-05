
#include "pacman_src_2images.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2image.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_debug_windows/std_geom_2rect.h"

struct t_mojo_graphics_Shader;
bbString bbDBType(t_mojo_graphics_Shader**);
bbString bbDBValue(t_mojo_graphics_Shader**);

// ***** Internal *****

void t_pacman_ImageCollection::gcMark(){
  bbGCMark(m__0images);
}

void t_pacman_ImageCollection::dbEmit(){
  bbDBEmit("_images",&m__0images);
}

t_pacman_ImageCollection::t_pacman_ImageCollection(bbString l_imageName,bbInt l_width,bbInt l_height,bbInt l_textureFlags){
  struct f0_t : public bbGCFrame{
    t_mojo_graphics_Image* l_imageStrip{};
    void gcMark(){
      bbGCMarkPtr(l_imageStrip);
    }
  }f0{};
  bbDBFrame db_f{"new:Void(imageName:String,width:Int,height:Int,textureFlags:mojo.graphics.TextureFlags)","D:/Dev/Monkey/Pacman/src/images.monkey2"};
  bbDBLocal("imageName",&l_imageName);
  bbDBLocal("width",&l_width);
  bbDBLocal("height",&l_height);
  bbDBLocal("textureFlags",&l_textureFlags);
  bbDBStmt(45064);
  f0.l_imageStrip=g_mojo_graphics_Image_Load(l_imageName,l_textureFlags,((t_mojo_graphics_Shader*)0));
  bbDBLocal("imageStrip",&f0.l_imageStrip);
  bbDBStmt(49160);
  bbInt l_count=(f0.l_imageStrip->m_Width()/l_width);
  bbDBLocal("count",&l_count);
  bbDBStmt(61442);
  this->m__0images=bbArray<bbGCVar<t_mojo_graphics_Image>>::create(l_count);
  bbDBStmt(65538);
  {
    bbDBLoop db_loop;
    bbInt l_index=bbInt(0);
    bbDBLocal("index",&l_index);
    bbDBStmt(65538);
    for(;(l_index<l_count);l_index+=1){
      struct f2_t : public bbGCFrame{
        t_mojo_graphics_Image* l_newImage{};
        void gcMark(){
          bbGCMarkPtr(l_newImage);
        }
      }f2{};
      bbDBBlock db_blk;
      bbDBStmt(73737);
      bbInt l_x=(l_index*l_width);
      bbDBLocal("x",&l_x);
      bbDBStmt(86025);
      f2.l_newImage=bbGCNew<t_mojo_graphics_Image>(f0.l_imageStrip,t_std_geom_Rect_1i(l_x,bbInt(0),(l_x+l_width),l_height));
      bbDBLocal("newImage",&f2.l_newImage);
      bbDBStmt(94211);
      this->m__0images->at(l_index)=f2.l_newImage;
    }
  }
}

bbArray<bbGCVar<t_mojo_graphics_Image>>* t_pacman_ImageCollection::m_Item(){
  bbDBFrame db_f{"Item:mojo.graphics.Image[]()","D:/Dev/Monkey/Pacman/src/images.monkey2"};
  t_pacman_ImageCollection*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(122882);
  return this->m__0images;
}

bbInt t_pacman_ImageCollection::m_Count(){
  bbDBFrame db_f{"Count:Int()","D:/Dev/Monkey/Pacman/src/images.monkey2"};
  t_pacman_ImageCollection*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(139266);
  return this->m__0images->length();
}
bbString bbDBType(t_pacman_ImageCollection**){
  return "pacman.ImageCollection";
}
bbString bbDBValue(t_pacman_ImageCollection**p){
  return bbDBObjectValue(*p);
}

void mx2_pacman_src_2images_init(){
  static bool done;
  if(done) return;
  done=true;
}

bbInit mx2_pacman_src_2images_init_v("pacman_src_2images",&mx2_pacman_src_2images_init);
