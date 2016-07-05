
#ifndef MX2_PACMAN_SRC_2SPRITES_H
#define MX2_PACMAN_SRC_2SPRITES_H

#include <bbmonkey.h>

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/monkey/monkey.buildv010/desktop_release_windows/monkey_types.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_release_windows/std_geom_2vec2.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_release_windows/std_graphics_2color.h"

struct t_std_collections_Stack_1Tt_pacman_Sprite_2;
struct t_mojo_graphics_Canvas;
struct t_mojo_graphics_Image;

// ***** Internal *****

struct t_pacman_Sprite;

extern bbGCRootVar<t_std_collections_Stack_1Tt_pacman_Sprite_2> g_pacman_Sprites;

extern void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_UpdateSprites();
extern void g_pacman_InitialiseSprites();

struct t_pacman_Sprite : public bbObject{

  const char *typeName()const{return "t_pacman_Sprite";}

  bbInt m_X=bbInt(0);
  bbInt m_Y=bbInt(0);
  bbInt m_Blend=1;
  t_std_graphics_Color m_Color{};
  bbGCVar<bbArray<bbGCVar<t_mojo_graphics_Image>>> m_Images{};
  bbInt m_Frame=bbInt(0);
  bbFloat m_Rotation=0.0f;
  t_std_geom_Vec2_1f m_Scale{};
  bbBool m_Enabled=true;

  void init();

  void gcMark();

  t_pacman_Sprite(bbArray<bbGCVar<t_mojo_graphics_Image>>* l_images,bbInt l_originX,bbInt l_originY);
  t_pacman_Sprite(t_mojo_graphics_Image* l_image,bbInt l_originX,bbInt l_originY);

  virtual void m_Update();
  void m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,t_std_geom_Vec2_1f l_position,bbBool l_flip);
  void m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,bbInt l_x,bbInt l_y,bbBool l_flip);
  void m_Render(t_mojo_graphics_Canvas* l_canvas);
  void m_Init(bbArray<bbGCVar<t_mojo_graphics_Image>>* l_images,bbFloat l_originX,bbFloat l_originY);

  t_pacman_Sprite(){
    init();
  }
};

#endif
