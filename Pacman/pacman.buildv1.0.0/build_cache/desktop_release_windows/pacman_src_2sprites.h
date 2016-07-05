
#ifndef MX2_PACMAN_SRC_2SPRITES_H
#define MX2_PACMAN_SRC_2SPRITES_H

#include <bbmonkey.h>

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/monkey/monkey.buildv1.0.0/desktop_release_windows/monkey_types.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_release_windows/std_geom_2vec2.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_release_windows/std_graphics_2color.h"

struct t_std_collections_Stack_1Tt_pacman_Sprite_2;
struct t_mojo_graphics_Canvas;
struct t_pacman_ImageCollection;

// ***** Internal *****

struct t_pacman_Sprite;
struct t_pacman_PacmanSprite;
struct t_pacman_GhostSprite;
struct t_pacman_BlinkyGhostSprite;
struct t_pacman_ClydeGhostSprite;
struct t_pacman_PinkyGhostSprite;
struct t_pacman_InkyGhostSprite;

extern bbGCRootVar<t_std_collections_Stack_1Tt_pacman_Sprite_2> g_pacman_Sprites;
extern bbGCRootVar<t_pacman_PacmanSprite> g_pacman_Yellow;
extern bbGCRootVar<t_pacman_BlinkyGhostSprite> g_pacman_Red;
extern bbGCRootVar<t_pacman_ClydeGhostSprite> g_pacman_Orange;
extern bbGCRootVar<t_pacman_PinkyGhostSprite> g_pacman_Pink;
extern bbGCRootVar<t_pacman_InkyGhostSprite> g_pacman_Cyan;

extern void g_pacman_SetSpriteSpeed();
extern void g_pacman_SetGhostReverseDirection();
extern void g_pacman_SetGhostMode(bbInt l_mode);
extern void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_UpdateSprites();
extern void g_pacman_InitialiseSprites();

struct t_pacman_Sprite : public bbObject{

  const char *typeName()const{return "t_pacman_Sprite";}

  bbFloat m_X=0.0f;
  bbFloat m_Y=0.0f;
  bbInt m_Blend=1;
  t_std_graphics_Color m_Color{};
  bbGCVar<t_pacman_ImageCollection> m_Images{};
  bbInt m_Frame=bbInt(0);
  bbFloat m_Rotation=0.0f;
  t_std_geom_Vec2_1f m_Scale{};
  bbBool m_Enabled=false;
  bbInt m_Dir=bbInt(0);
  bbInt m_PrevDir=bbInt(0);
  bbFloat m_Speed=1.0f;

  void init();

  void gcMark();

  t_pacman_Sprite(bbString l_image);

  virtual void m_Update()=0;
  t_std_geom_Vec2_1f m_Tile();
  virtual void m_SetSpeed()=0;
  void m_SetPosition(t_std_geom_Vec2_1f l_tile,bbInt l_offsetX,bbInt l_offsetY);
  void m_SetPosition(bbInt l_x,bbInt l_y,bbInt l_offsetX,bbInt l_offsetY);
  void m_SetDirection(bbInt l_dir);
  virtual void m_Reset()=0;
  void m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,t_std_geom_Vec2_1f l_position,bbBool l_flip);
  virtual void m_Render(t_mojo_graphics_Canvas* l_canvas);
  bbBool m_IsCentreTile(bbFloat l_x,bbFloat l_y,bbInt l_xOffset);
  bbInt m_GetNewDirection(t_std_geom_Vec2_1f l_tile);
  bbBool m_CanMoveDirection(t_std_geom_Vec2_1f l_tile,bbInt l_moveDir);

  t_pacman_Sprite(){
    init();
  }
};

struct t_pacman_PacmanSprite : public t_pacman_Sprite{

  const char *typeName()const{return "t_pacman_PacmanSprite";}

  t_pacman_PacmanSprite(bbString l_image);

  void m_Update();
  void m_SetSpeed();
  void m_Reset();

  t_pacman_PacmanSprite(){
  }
};

struct t_pacman_GhostSprite : public t_pacman_Sprite{

  using t_pacman_Sprite::m_Render;
  const char *typeName()const{return "t_pacman_GhostSprite";}

  t_std_geom_Vec2_1f m_ScatterTargetTile{};
  bbInt m_Mode=bbInt(3);
  bbBool m_ReverseDirection=false;
  bbBool m_ReleaseFromPen=false;
  bbInt m_DotCounter=bbInt(0);

  void init();

  t_pacman_GhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile);

  void m_Update();
  void m_SetSpeed();
  void m_Render(t_mojo_graphics_Canvas* l_canvas);
  virtual t_std_geom_Vec2_1f m_GetTargetTile()=0;
  bbInt m_GetDistanceToTarget(bbInt l_x1,bbInt l_y1,bbInt l_x2,bbInt l_y2);
  bbInt m_FindTargetDistance(t_std_geom_Vec2_1f l_tile,t_std_geom_Vec2_1f l_targetTile,bbInt l_dirToTarget);

  t_pacman_GhostSprite(){
    init();
  }
};

struct t_pacman_BlinkyGhostSprite : public t_pacman_GhostSprite{

  const char *typeName()const{return "t_pacman_BlinkyGhostSprite";}

  t_pacman_BlinkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile);

  void m_Reset();
  t_std_geom_Vec2_1f m_GetTargetTile();

  t_pacman_BlinkyGhostSprite(){
  }
};

struct t_pacman_ClydeGhostSprite : public t_pacman_GhostSprite{

  const char *typeName()const{return "t_pacman_ClydeGhostSprite";}

  t_pacman_ClydeGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile);

  void m_Reset();
  t_std_geom_Vec2_1f m_GetTargetTile();

  t_pacman_ClydeGhostSprite(){
  }
};

struct t_pacman_PinkyGhostSprite : public t_pacman_GhostSprite{

  const char *typeName()const{return "t_pacman_PinkyGhostSprite";}

  t_pacman_PinkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile);

  void m_Reset();
  t_std_geom_Vec2_1f m_GetTargetTile();

  t_pacman_PinkyGhostSprite(){
  }
};

struct t_pacman_InkyGhostSprite : public t_pacman_GhostSprite{

  const char *typeName()const{return "t_pacman_InkyGhostSprite";}

  t_pacman_InkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile);

  void m_Reset();
  t_std_geom_Vec2_1f m_GetTargetTile();

  t_pacman_InkyGhostSprite(){
  }
};

#endif
