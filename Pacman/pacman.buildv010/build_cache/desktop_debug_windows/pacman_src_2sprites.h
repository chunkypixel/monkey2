
#ifndef MX2_PACMAN_SRC_2SPRITES_H
#define MX2_PACMAN_SRC_2SPRITES_H

#include <bbmonkey.h>

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/monkey/monkey.buildv010/desktop_debug_windows/monkey_types.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_geom_2vec2.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_graphics_2color.h"

struct t_std_collections_Stack_1Tt_pacman_Sprite_2;
bbString bbDBType(t_std_collections_Stack_1Tt_pacman_Sprite_2**);
bbString bbDBValue(t_std_collections_Stack_1Tt_pacman_Sprite_2**);
struct t_mojo_graphics_Canvas;
bbString bbDBType(t_mojo_graphics_Canvas**);
bbString bbDBValue(t_mojo_graphics_Canvas**);
struct t_mojo_graphics_Image;
bbString bbDBType(t_mojo_graphics_Image**);
bbString bbDBValue(t_mojo_graphics_Image**);

// ***** Internal *****

struct t_pacman_Sprite;
struct t_pacman_PacmanSprite;
struct t_pacman_GhostSprite;

extern bbGCRootVar<t_std_collections_Stack_1Tt_pacman_Sprite_2> g_pacman_Sprites;
extern bbGCRootVar<t_pacman_PacmanSprite> g_pacman_Yellow;
extern bbGCRootVar<t_pacman_GhostSprite> g_pacman_Red;
extern bbGCRootVar<t_pacman_Sprite> g_pacman_Orange;
extern bbGCRootVar<t_pacman_Sprite> g_pacman_Pink;
extern bbGCRootVar<t_pacman_Sprite> g_pacman_Cyan;

extern void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_UpdateSprites();
extern void g_pacman_InitialiseSprites();

struct t_pacman_Sprite : public bbObject{

  const char *typeName()const{return "t_pacman_Sprite";}

  t_std_geom_Vec2_1i m_Tile{};
  t_std_geom_Vec2_1i m_tempTile{};
  bbFloat m_X=0.0f;
  bbFloat m_Y=0.0f;
  bbInt m_Blend=1;
  t_std_graphics_Color m_Color{};
  bbGCVar<bbArray<bbGCVar<t_mojo_graphics_Image>>> m_Images{};
  bbInt m_Frame=bbInt(0);
  bbFloat m_Rotation=0.0f;
  t_std_geom_Vec2_1f m_Scale{};
  bbBool m_Enabled=false;
  bbInt m_Dir=bbInt(0);

  void init();

  void gcMark();
  void dbEmit();

  t_pacman_Sprite(t_mojo_graphics_Image* l_image,bbInt l_frameWidth,bbInt l_frameHeight);

  virtual void m_Update();
  void m_SetPosition(t_std_geom_Vec2_1i l_tile);
  void m_SetPosition(bbInt l_x,bbInt l_y);
  void m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,t_std_geom_Vec2_1f l_position,bbBool l_flip);
  void m_Render(t_mojo_graphics_Canvas* l_canvas);
  bbBool m_IsCentreTile(bbFloat l_x,bbFloat l_y);
  bbInt m_GetNewDirection(t_std_geom_Vec2_1i l_tile,bbInt l_currentDir);

  t_pacman_Sprite(){
    init();
  }
};
bbString bbDBType(t_pacman_Sprite**);
bbString bbDBValue(t_pacman_Sprite**);

struct t_pacman_PacmanSprite : public t_pacman_Sprite{

  const char *typeName()const{return "t_pacman_PacmanSprite";}

  void dbEmit();

  t_pacman_PacmanSprite(t_mojo_graphics_Image* l_image,bbInt l_frameWidth,bbInt l_frameHeight);

  void m_Update();
  bbBool m_CanContinueDirection(t_std_geom_Vec2_1i l_tile,bbInt l_currentDir);

  t_pacman_PacmanSprite(){
  }
};
bbString bbDBType(t_pacman_PacmanSprite**);
bbString bbDBValue(t_pacman_PacmanSprite**);

struct t_pacman_GhostSprite : public t_pacman_Sprite{

  const char *typeName()const{return "t_pacman_GhostSprite";}

  t_std_geom_Vec2_1i m_ScatterTargetTile{};
  bbInt m_Mode=bbInt(0);

  void init();
  void dbEmit();

  t_pacman_GhostSprite(t_mojo_graphics_Image* l_image,bbInt l_frameWidth,bbInt l_frameHeight,t_std_geom_Vec2_1i l_scatterTargetTile);

  t_pacman_GhostSprite(){
    init();
  }
};
bbString bbDBType(t_pacman_GhostSprite**);
bbString bbDBValue(t_pacman_GhostSprite**);

#endif
