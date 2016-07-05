
#include "pacman_src_2sprites.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_release_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_release_windows/mojo_graphics_2image.h"
#include "pacman_std_collections_2stack.h"

// ***** Internal *****

bbGCRootVar<t_std_collections_Stack_1Tt_pacman_Sprite_2> g_pacman_Sprites;

void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas){
  {
    bbInt l_i=bbInt(0);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      if(g_pacman_Sprites->m__idx(l_i)->m_Enabled){
        struct f3_t : public bbGCFrame{
          t_pacman_Sprite* t0{};
          void gcMark(){
            bbGCMark(t0);
          }
        }f3{};
        (f3.t0=g_pacman_Sprites->m__idx(l_i))->m_Render(l_canvas);
      }
    }
  }
}

void g_pacman_UpdateSprites(){
  {
    bbInt l_i=bbInt(0);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      if(g_pacman_Sprites->m__idx(l_i)->m_Enabled){
        struct f3_t : public bbGCFrame{
          t_pacman_Sprite* t0{};
          void gcMark(){
            bbGCMark(t0);
          }
        }f3{};
        (f3.t0=g_pacman_Sprites->m__idx(l_i))->m_Update();
      }
    }
  }
}

void g_pacman_InitialiseSprites(){
}

void t_pacman_Sprite::init(){
  m_Color=t_std_graphics_Color(1.0f,1.0f,1.0f,1.0f);
  m_Scale=t_std_geom_Vec2_1f(1.0f,1.0f);
}

void t_pacman_Sprite::gcMark(){
  bbGCMark(m_Images);
}

t_pacman_Sprite::t_pacman_Sprite(bbArray<bbGCVar<t_mojo_graphics_Image>>* l_images,bbInt l_originX,bbInt l_originY){
  init();
  this->m_Init(l_images,bbFloat(l_originX),bbFloat(l_originY));
}

t_pacman_Sprite::t_pacman_Sprite(t_mojo_graphics_Image* l_image,bbInt l_originX,bbInt l_originY){
  init();
  struct f0_t : public bbGCFrame{
    bbArray<bbGCVar<t_mojo_graphics_Image>>* t0{};
    void gcMark(){
      bbGCMark(t0);
    }
  }f0{};
  this->m_Init(f0.t0=bbArray<bbGCVar<t_mojo_graphics_Image>>::create({l_image},1),bbFloat(l_originX),bbFloat(l_originY));
}

void t_pacman_Sprite::m_Update(){
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,t_std_geom_Vec2_1f l_position,bbBool l_flip){
  t_std_geom_Vec2_1f l_scale=this->m_Scale;
  if((l_frame==-1)){
    l_frame=this->m_Frame;
  }
  if(l_flip){
    l_scale=t_std_geom_Vec2_1f(bbFloat(-1),1.0f);
  }
  l_canvas->m_BlendMode(this->m_Blend);
  l_canvas->m_Color(this->m_Color);
  l_canvas->m_DrawImage(this->m_Images->at(l_frame),l_position,this->m_Rotation,l_scale);
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,bbInt l_x,bbInt l_y,bbBool l_flip){
  this->m_Render(l_canvas,l_frame,t_std_geom_Vec2_1f(bbFloat(l_x),bbFloat(l_y)),l_flip);
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas){
  this->m_Render(l_canvas,this->m_Frame,t_std_geom_Vec2_1f(bbFloat(this->m_X),bbFloat(this->m_Y)),false);
}

void t_pacman_Sprite::m_Init(bbArray<bbGCVar<t_mojo_graphics_Image>>* l_images,bbFloat l_originX,bbFloat l_originY){
  bbFloat l_handleX=0.0f;
  bbFloat l_handleY=0.0f;
  if((l_originX>0.0f)){
    l_handleX=(l_originX/bbFloat(l_images->at(bbInt(0))->m_Width()));
  }
  if((l_originY>0.0f)){
    l_handleY=(l_originY/bbFloat(l_images->at(bbInt(0))->m_Height()));
  }
  this->m_Images=l_images;
  {
    bbInt l_i=bbInt(0);
    for(;(l_i<this->m_Images->length());l_i+=1){
      this->m_Images->at(l_i)->m_Handle(t_std_geom_Vec2_1f(l_handleX,l_handleY));
    }
  }
  g_pacman_Sprites->m_Push(this);
}

void mx2_pacman_src_2sprites_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_Sprites=bbGCNew<t_std_collections_Stack_1Tt_pacman_Sprite_2>();
}

bbInit mx2_pacman_src_2sprites_init_v("pacman_src_2sprites",&mx2_pacman_src_2sprites_init);
