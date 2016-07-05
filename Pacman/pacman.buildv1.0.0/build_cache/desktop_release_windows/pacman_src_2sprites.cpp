
#include "pacman_src_2sprites.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2image.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_input_2keyboard.h"
#include "pacman_pacman.h"
#include "pacman_src_2images.h"
#include "pacman_std_collections_2stack.h"

extern bbGCRootVar<bbArray<bbInt,2>> g_pacman_Grid;
extern bbInt g_pacman_GridHeight;
extern bbInt g_pacman_GridWidth;

// ***** Internal *****

bbGCRootVar<t_std_collections_Stack_1Tt_pacman_Sprite_2> g_pacman_Sprites;
bbGCRootVar<t_pacman_PacmanSprite> g_pacman_Yellow;
bbGCRootVar<t_pacman_BlinkyGhostSprite> g_pacman_Red;
bbGCRootVar<t_pacman_ClydeGhostSprite> g_pacman_Orange;
bbGCRootVar<t_pacman_PinkyGhostSprite> g_pacman_Pink;
bbGCRootVar<t_pacman_InkyGhostSprite> g_pacman_Cyan;

void g_pacman_SetSpriteSpeed(){
  {
    bbInt l_i=bbInt(0);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      struct f2_t : public bbGCFrame{
        t_pacman_Sprite* t0{};
        void gcMark(){
          bbGCMarkPtr(t0);
        }
      }f2{};
      (f2.t0=g_pacman_Sprites->m__idx(l_i))->m_SetSpeed();
    }
  }
}

void g_pacman_SetGhostReverseDirection(){
  {
    bbInt l_i=bbInt(0);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      struct f2_t : public bbGCFrame{
        t_pacman_GhostSprite* l_ghost{};
        void gcMark(){
          bbGCMarkPtr(l_ghost);
        }
      }f2{};
      f2.l_ghost=bb_object_cast<t_pacman_GhostSprite*>(g_pacman_Sprites->m__idx(l_i));
      if((f2.l_ghost!=((t_pacman_GhostSprite*)0))){
        if(f2.l_ghost->m_Mode==bbInt(3)||f2.l_ghost->m_Mode==bbInt(4)){
          f2.l_ghost->m_ReverseDirection=true;
        }
      }
    }
  }
}

void g_pacman_SetGhostMode(bbInt l_mode){
  {
    bbInt l_i=bbInt(0);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      struct f2_t : public bbGCFrame{
        t_pacman_GhostSprite* l_ghost{};
        void gcMark(){
          bbGCMarkPtr(l_ghost);
        }
      }f2{};
      f2.l_ghost=bb_object_cast<t_pacman_GhostSprite*>(g_pacman_Sprites->m__idx(l_i));
      if(((f2.l_ghost!=((t_pacman_GhostSprite*)0))&&(f2.l_ghost->m_Mode>bbInt(2)))){
        f2.l_ghost->m_Mode=l_mode;
      }
    }
  }
  g_pacman_SetSpriteSpeed();
}

void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas){
  {
    bbInt l_i=bbInt(0);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      if(g_pacman_Sprites->m__idx(l_i)->m_Enabled){
        struct f3_t : public bbGCFrame{
          t_pacman_Sprite* t0{};
          void gcMark(){
            bbGCMarkPtr(t0);
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
            bbGCMarkPtr(t0);
          }
        }f3{};
        (f3.t0=g_pacman_Sprites->m__idx(l_i))->m_Update();
      }
    }
  }
}

void g_pacman_InitialiseSprites(){
  g_pacman_Yellow=bbGCNew<t_pacman_PacmanSprite>(BB_T("asset::yellow.png"));
  g_pacman_Red=bbGCNew<t_pacman_BlinkyGhostSprite>(BB_T("asset::redt.png"),t_std_geom_Vec2_1f(25.0f,0.0f));
  g_pacman_Pink=bbGCNew<t_pacman_PinkyGhostSprite>(BB_T("asset::pinkt.png"),t_std_geom_Vec2_1f(2.0f,0.0f));
  g_pacman_Orange=bbGCNew<t_pacman_ClydeGhostSprite>(BB_T("asset::oranget.png"),t_std_geom_Vec2_1f(0.0f,35.0f));
  g_pacman_Cyan=bbGCNew<t_pacman_InkyGhostSprite>(BB_T("asset::cyant.png"),t_std_geom_Vec2_1f(27.0f,35.0f));
}

void t_pacman_Sprite::init(){
  m_Color=t_std_graphics_Color(1.0f,1.0f,1.0f,1.0f);
  m_Scale=t_std_geom_Vec2_1f(1.0f,1.0f);
}

void t_pacman_Sprite::gcMark(){
  bbGCMark(m_Images);
}

t_pacman_Sprite::t_pacman_Sprite(bbString l_image){
  init();
  this->m_Images=bbGCNew<t_pacman_ImageCollection>(l_image,16,16,2);
  this->m_Reset();
  g_pacman_Sprites->m_Push(this);
}

t_std_geom_Vec2_1f t_pacman_Sprite::m_Tile(){
  return t_std_geom_Vec2_1f(bbFloat(bbInt((this->m_X/8.0f))),bbFloat(bbInt((this->m_Y/8.0f))));
}

void t_pacman_Sprite::m_SetPosition(t_std_geom_Vec2_1f l_tile,bbInt l_offsetX,bbInt l_offsetY){
  this->m_X=((l_tile.m_X()*8.0f)+bbFloat(l_offsetX));
  this->m_Y=((l_tile.m_Y()*8.0f)+bbFloat(l_offsetY));
}

void t_pacman_Sprite::m_SetPosition(bbInt l_x,bbInt l_y,bbInt l_offsetX,bbInt l_offsetY){
  this->m_SetPosition(t_std_geom_Vec2_1f(bbFloat(l_x),bbFloat(l_y)),l_offsetX,l_offsetY);
}

void t_pacman_Sprite::m_SetDirection(bbInt l_dir){
  this->m_PrevDir=this->m_Dir;
  this->m_Dir=l_dir;
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,t_std_geom_Vec2_1f l_position,bbBool l_flip){
  struct f0_t : public bbGCFrame{
    t_mojo_graphics_Image* t0{};
    void gcMark(){
      bbGCMarkPtr(t0);
    }
  }f0{};
  t_std_geom_Vec2_1f l_scale=this->m_Scale;
  if((l_frame==-1)){
    l_frame=this->m_Frame;
  }
  if(l_flip){
    l_scale=t_std_geom_Vec2_1f(bbFloat(-1),1.0f);
  }
  l_canvas->m_BlendMode(this->m_Blend);
  l_canvas->m_Color(this->m_Color);
  l_canvas->m_DrawImage(f0.t0=this->m_Images->m_Item()->at(l_frame),l_position,this->m_Rotation,l_scale);
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas){
  if(g_pacman_window->m_IsDebug){
    l_canvas->m_Color(g_std_graphics_Color_Green);
    l_canvas->m_DrawRect(bbFloat((g_pacman_DisplayOffset.m_X()+bbInt((this->m_Tile().m_X()*8.0f)))),bbFloat((g_pacman_DisplayOffset.m_Y()+bbInt((this->m_Tile().m_Y()*8.0f)))),8.0f,8.0f);
  }
  l_canvas->m_Color(g_std_graphics_Color_White);
  this->m_Render(l_canvas,this->m_Dir,t_std_geom_Vec2_1f(bbFloat(((g_pacman_DisplayOffset.m_X()+bbInt(this->m_X))-8)),bbFloat(((g_pacman_DisplayOffset.m_Y()+bbInt(this->m_Y))-8))),false);
}

bbBool t_pacman_Sprite::m_IsCentreTile(bbFloat l_x,bbFloat l_y,bbInt l_xOffset){
  return (((bbInt(l_x)%8)==l_xOffset)&&((bbInt(l_y)%8)==4));
}

bbInt t_pacman_Sprite::m_GetNewDirection(t_std_geom_Vec2_1f l_tile){
  if((((g_pacman_Grid->at(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-1.0f)))==bbInt(0))&&(this->m_Dir!=bbInt(2)))&&(this->m_PrevDir!=bbInt(2)))){
    return bbInt(0);
  }else if((((g_pacman_Grid->at(bbInt((l_tile.m_X()-1.0f)),bbInt(l_tile.m_Y()))==bbInt(0))&&(this->m_Dir!=bbInt(3)))&&(this->m_PrevDir!=bbInt(3)))){
    return bbInt(1);
  }else if((((g_pacman_Grid->at(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+1.0f)))==bbInt(0))&&(this->m_Dir!=bbInt(0)))&&(this->m_PrevDir!=bbInt(0)))){
    return bbInt(2);
  }
  return bbInt(3);
}

bbBool t_pacman_Sprite::m_CanMoveDirection(t_std_geom_Vec2_1f l_tile,bbInt l_moveDir){
  if(l_moveDir==bbInt(0)){
    if(((l_tile.m_Y()-1.0f)>=0.0f)){
      return (g_pacman_Grid->at(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-1.0f)))==bbInt(0));
    }
  }else if(l_moveDir==bbInt(2)){
    if(((l_tile.m_Y()+1.0f)<bbFloat(g_pacman_GridHeight))){
      return (g_pacman_Grid->at(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+1.0f)))==bbInt(0));
    }
  }else if(l_moveDir==bbInt(1)){
    if(((l_tile.m_X()-1.0f)>=0.0f)){
      return (g_pacman_Grid->at(bbInt((l_tile.m_X()-1.0f)),bbInt(l_tile.m_Y()))==bbInt(0));
    }
  }else if(l_moveDir==bbInt(3)){
    if(((l_tile.m_X()+1.0f)<bbFloat(g_pacman_GridWidth))){
      return (g_pacman_Grid->at(bbInt((l_tile.m_X()+1.0f)),bbInt(l_tile.m_Y()))==bbInt(0));
    }
  }
  return false;
}

t_pacman_PacmanSprite::t_pacman_PacmanSprite(bbString l_image):t_pacman_Sprite(l_image){
}

void t_pacman_PacmanSprite::m_Update(){
  bbBool l_isCentreTile=this->m_IsCentreTile(this->m_X,this->m_Y,4);
  if(((l_isCentreTile&&(this->m_Tile().m_X()>=bbFloat((g_pacman_GridWidth-1))))&&(this->m_Dir==bbInt(3)))){
    this->m_SetPosition(bbInt(0),bbInt(this->m_Tile().m_Y()),bbInt(0),4);
  }
  if(((l_isCentreTile&&(this->m_Tile().m_X()<=0.0f))&&(this->m_Dir==bbInt(1)))){
    this->m_SetPosition((g_pacman_GridWidth-1),bbInt(this->m_Tile().m_Y()),7,4);
  }
  bbBool l_isKeyUp=g_mojo_input_Keyboard->m_KeyDown(210);
  bbBool l_isKeyDown=g_mojo_input_Keyboard->m_KeyDown(209);
  bbBool l_isKeyLeft=g_mojo_input_Keyboard->m_KeyDown(208);
  bbBool l_isKeyRight=g_mojo_input_Keyboard->m_KeyDown(207);
  bbBool l_isKeysPressed=(((l_isKeyUp||l_isKeyDown)||l_isKeyLeft)||l_isKeyRight);
  if(((!l_isKeysPressed&&l_isCentreTile)&&!this->m_CanMoveDirection(this->m_Tile(),this->m_Dir))){
    return;
  }
  bbFloat l_moveX=this->m_X;
  bbFloat l_moveY=this->m_Y;
  if(l_isKeyDown){
    bbBool l_canContinueDown=this->m_CanMoveDirection(this->m_Tile(),bbInt(2));
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(0)))&&l_canContinueDown)){
      this->m_SetDirection(bbInt(2));
    }else if((l_isCentreTile&&l_canContinueDown)){
      this->m_SetDirection(bbInt(2));
    }
  }else if(l_isKeyUp){
    bbBool l_canContinueUp=this->m_CanMoveDirection(this->m_Tile(),bbInt(0));
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(2)))&&l_canContinueUp)){
      this->m_SetDirection(bbInt(0));
    }else if((l_isCentreTile&&l_canContinueUp)){
      this->m_SetDirection(bbInt(0));
    }
  }else if(l_isKeyLeft){
    bbBool l_canContinueLeft=this->m_CanMoveDirection(this->m_Tile(),bbInt(1));
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(3)))&&l_canContinueLeft)){
      this->m_SetDirection(bbInt(1));
    }else if((l_isCentreTile&&l_canContinueLeft)){
      this->m_SetDirection(bbInt(1));
    }
  }else if(l_isKeyRight){
    bbBool l_canContinueRight=this->m_CanMoveDirection(this->m_Tile(),bbInt(3));
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(1)))&&l_canContinueRight)){
      this->m_SetDirection(bbInt(3));
    }else if((l_isCentreTile&&l_canContinueRight)){
      this->m_SetDirection(bbInt(3));
    }
  }
  if(((l_isKeysPressed&&l_isCentreTile)&&!this->m_CanMoveDirection(this->m_Tile(),this->m_Dir))){
    return;
  }
  if(this->m_Dir==bbInt(0)){
    l_moveY-=this->m_Speed;
  }else if(this->m_Dir==bbInt(1)){
    l_moveX-=this->m_Speed;
  }else if(this->m_Dir==bbInt(2)){
    l_moveY+=this->m_Speed;
  }else if(this->m_Dir==bbInt(3)){
    l_moveX+=this->m_Speed;
  }
  this->m_X=l_moveX;
  this->m_Y=l_moveY;
}

void t_pacman_PacmanSprite::m_SetSpeed(){
  this->m_Speed=0.80f;
}

void t_pacman_PacmanSprite::m_Reset(){
}

void t_pacman_GhostSprite::init(){
  m_ScatterTargetTile=t_std_geom_Vec2_1f(0.0f,0.0f);
}

t_pacman_GhostSprite::t_pacman_GhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_Sprite(l_image){
  init();
  this->m_ScatterTargetTile=l_scatterTargetTile;
}

void t_pacman_GhostSprite::m_Update(){
  if(!g_pacman_window->m_MoveGhosts){
    return;
  }
  bbFloat l_moveX=this->m_X;
  bbFloat l_moveY=this->m_Y;
  bbInt l_xTileOffset=4;
  if((this->m_Mode==bbInt(0))){
    l_xTileOffset=bbInt(0);
  }
  if(this->m_Dir==bbInt(0)){
    l_moveY-=this->m_Speed;
  }else if(this->m_Dir==bbInt(1)){
    l_moveX-=this->m_Speed;
  }else if(this->m_Dir==bbInt(2)){
    l_moveY+=this->m_Speed;
  }else if(this->m_Dir==bbInt(3)){
    l_moveX+=this->m_Speed;
  }
  bbBool l_isCentreTile=this->m_IsCentreTile(l_moveX,l_moveY,l_xTileOffset);
  if((this->m_ReverseDirection&&l_isCentreTile)){
    bbInt l_reverseDir=((this->m_Dir+2)%4);
    if(!this->m_CanMoveDirection(this->m_Tile(),l_reverseDir)){
      l_reverseDir=((this->m_PrevDir+2)%4);
    }
    this->m_SetDirection(l_reverseDir);
    this->m_ReverseDirection=false;
  }
  if(((l_isCentreTile&&(this->m_Tile().m_X()>=bbFloat((g_pacman_GridWidth-1))))&&(this->m_Dir==bbInt(3)))){
    this->m_SetPosition(bbInt(0),bbInt(this->m_Tile().m_Y()),bbInt(0),4);
    l_moveX=this->m_X;
    l_moveY=this->m_Y;
  }else if(((l_isCentreTile&&(this->m_Tile().m_X()<=0.0f))&&(this->m_Dir==bbInt(1)))){
    this->m_SetPosition((g_pacman_GridWidth-1),bbInt(this->m_Tile().m_Y()),7,4);
    l_moveX=this->m_X;
    l_moveY=this->m_Y;
  }
  t_std_geom_Vec2_1f l_nextTile=t_std_geom_Vec2_1f(bbFloat(bbInt((l_moveX/8.0f))),bbFloat(bbInt((l_moveY/8.0f))));
  if(this->m_Mode==bbInt(0)){
    if(!this->m_CanMoveDirection(l_nextTile,this->m_Dir)){
      this->m_Dir=((this->m_Dir+2)%4);
    }
  }else if(this->m_Mode==bbInt(1)){
  }else{
    if(this->m_IsCentreTile(l_moveX,l_moveY,l_xTileOffset)){
      if(this->m_Mode==bbInt(3)||this->m_Mode==bbInt(4)||this->m_Mode==bbInt(2)){
        t_std_geom_Vec2_1f l_targetTile=this->m_GetTargetTile();
        bbInt l_oppositeDir=((this->m_Dir+2)%4);
        bbInt l_oppositePrevDir=((this->m_PrevDir+2)%4);
        bbInt l_targetDir=-1;
        bbInt l_targetDistance=-1;
        {
          bbInt l_dir=bbInt(0);
          for(;(l_dir<=3);l_dir+=1){
            bbInt l_checkTargetDistance=this->m_FindTargetDistance(l_nextTile,l_targetTile,l_dir);
            if(((((l_checkTargetDistance>=bbInt(0))&&((l_checkTargetDistance<l_targetDistance)||(l_targetDistance<bbInt(0))))&&(l_dir!=l_oppositeDir))&&(l_dir!=l_oppositePrevDir))){
              l_targetDistance=l_checkTargetDistance;
              l_targetDir=l_dir;
            }
          }
        }
        this->m_SetDirection(l_targetDir);
      }else if(this->m_Mode==bbInt(5)){
        this->m_SetDirection(this->m_GetNewDirection(l_nextTile));
      }
    }
  }
  this->m_X=l_moveX;
  this->m_Y=l_moveY;
}

void t_pacman_GhostSprite::m_SetSpeed(){
  if(this->m_Mode==bbInt(0)){
    this->m_Speed=0.50f;
  }else if(this->m_Mode==bbInt(5)){
    this->m_Speed=0.50f;
  }else{
    this->m_Speed=0.75f;
  }
}

void t_pacman_GhostSprite::m_Render(t_mojo_graphics_Canvas* l_canvas){
  t_pacman_Sprite::m_Render(l_canvas);
  if(g_pacman_window->m_IsDebug){
    if(this->m_Mode==bbInt(3)||this->m_Mode==bbInt(4)){
      t_std_geom_Vec2_1f l_targetTile=this->m_GetTargetTile();
      l_canvas->m_Color(g_std_graphics_Color_Green);
      l_canvas->m_DrawLine(((bbFloat(g_pacman_DisplayOffset.m_X())+(this->m_Tile().m_X()*8.0f))+4.0f),((bbFloat(g_pacman_DisplayOffset.m_Y())+(this->m_Tile().m_Y()*8.0f))+4.0f),((bbFloat(g_pacman_DisplayOffset.m_X())+(l_targetTile.m_X()*8.0f))+4.0f),((bbFloat(g_pacman_DisplayOffset.m_Y())+(l_targetTile.m_Y()*8.0f))+4.0f));
    }
  }
}

bbInt t_pacman_GhostSprite::m_GetDistanceToTarget(bbInt l_x1,bbInt l_y1,bbInt l_x2,bbInt l_y2){
  return (((l_x2-l_x1)*(l_x2-l_x1))+((l_y2-l_y1)*(l_y2-l_y1)));
}

bbInt t_pacman_GhostSprite::m_FindTargetDistance(t_std_geom_Vec2_1f l_tile,t_std_geom_Vec2_1f l_targetTile,bbInt l_dirToTarget){
  if(l_dirToTarget==bbInt(0)){
    if(((l_tile.m_Y()>0.0f)&&(g_pacman_Grid->at(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-1.0f)))==bbInt(0)))){
      return this->m_GetDistanceToTarget(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-2.0f)),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }else if(l_dirToTarget==bbInt(2)){
    if(((l_tile.m_Y()<bbFloat((g_pacman_GridHeight-1)))&&(g_pacman_Grid->at(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+1.0f)))==bbInt(0)))){
      return this->m_GetDistanceToTarget(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+2.0f)),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }else if(l_dirToTarget==bbInt(1)){
    if(((l_tile.m_X()>0.0f)&&(g_pacman_Grid->at(bbInt((l_tile.m_X()-1.0f)),bbInt(l_tile.m_Y()))==bbInt(0)))){
      return this->m_GetDistanceToTarget(bbInt((l_tile.m_X()-2.0f)),bbInt(l_tile.m_Y()),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }else if(l_dirToTarget==bbInt(3)){
    if(((l_tile.m_X()<bbFloat((g_pacman_GridWidth-1)))&&(g_pacman_Grid->at(bbInt((l_tile.m_X()+1.0f)),bbInt(l_tile.m_Y()))==bbInt(0)))){
      return this->m_GetDistanceToTarget(bbInt((l_tile.m_X()+2.0f)),bbInt(l_tile.m_Y()),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }
  return -1;
}

t_pacman_BlinkyGhostSprite::t_pacman_BlinkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
}

void t_pacman_BlinkyGhostSprite::m_Reset(){
  this->m_SetPosition(13,14,4,4);
  this->m_SetDirection(bbInt(1));
  this->m_Mode=bbInt(3);
  this->m_SetSpeed();
  this->m_DotCounter=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_BlinkyGhostSprite::m_GetTargetTile(){
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  if((this->m_Mode==bbInt(4))){
    l_targetTile=this->m_ScatterTargetTile;
  }
  return l_targetTile;
}

t_pacman_ClydeGhostSprite::t_pacman_ClydeGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
}

void t_pacman_ClydeGhostSprite::m_Reset(){
  this->m_SetPosition(16,17,bbInt(0),4);
  this->m_SetDirection(bbInt(0));
  this->m_Mode=bbInt(0);
  this->m_SetSpeed();
  this->m_DotCounter=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_ClydeGhostSprite::m_GetTargetTile(){
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  if(this->m_Mode==bbInt(3)){
    bbInt l_distanceToYellow=this->m_GetDistanceToTarget(bbInt(this->m_Tile().m_X()),bbInt(this->m_Tile().m_Y()),bbInt(g_pacman_Yellow->m_Tile().m_X()),bbInt(g_pacman_Yellow->m_Tile().m_Y()));
    if((l_distanceToYellow>8)){
      l_targetTile=this->m_ScatterTargetTile;
    }
  }else if(this->m_Mode==bbInt(4)){
    l_targetTile=this->m_ScatterTargetTile;
  }
  return l_targetTile;
}

t_pacman_PinkyGhostSprite::t_pacman_PinkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
}

void t_pacman_PinkyGhostSprite::m_Reset(){
  this->m_SetPosition(14,17,bbInt(0),4);
  this->m_SetDirection(bbInt(2));
  this->m_Mode=bbInt(0);
  this->m_SetSpeed();
  this->m_DotCounter=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_PinkyGhostSprite::m_GetTargetTile(){
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  if(this->m_Mode==bbInt(3)){
    if(g_pacman_Yellow->m_Dir==bbInt(0)){
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-4.0f),(g_pacman_Yellow->m_Tile().m_Y()-4.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(2)){
      l_targetTile=t_std_geom_Vec2_1f(g_pacman_Yellow->m_Tile().m_X(),(g_pacman_Yellow->m_Tile().m_Y()+4.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(1)){
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-4.0f),g_pacman_Yellow->m_Tile().m_Y());
    }else if(g_pacman_Yellow->m_Dir==bbInt(3)){
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()+4.0f),g_pacman_Yellow->m_Tile().m_Y());
    }
    if((l_targetTile.m_X()>=bbFloat(g_pacman_GridWidth))){
      l_targetTile.m_X(bbFloat((g_pacman_GridWidth-1)));
    }
    if((l_targetTile.m_X()<0.0f)){
      l_targetTile.m_X(0.0f);
    }
    if((l_targetTile.m_Y()>=bbFloat(g_pacman_GridHeight))){
      l_targetTile.m_Y(bbFloat((g_pacman_GridHeight-1)));
    }
    if((l_targetTile.m_Y()<0.0f)){
      l_targetTile.m_Y(0.0f);
    }
  }else if(this->m_Mode==bbInt(4)){
    l_targetTile=this->m_ScatterTargetTile;
  }
  return l_targetTile;
}

t_pacman_InkyGhostSprite::t_pacman_InkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
}

void t_pacman_InkyGhostSprite::m_Reset(){
  this->m_SetPosition(12,17,bbInt(0),4);
  this->m_SetDirection(bbInt(0));
  this->m_Mode=bbInt(0);
  this->m_SetSpeed();
  this->m_DotCounter=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_InkyGhostSprite::m_GetTargetTile(){
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  if(this->m_Mode==bbInt(3)){
    if(g_pacman_Yellow->m_Dir==bbInt(0)){
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-2.0f),(g_pacman_Yellow->m_Tile().m_Y()-2.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(2)){
      l_targetTile=t_std_geom_Vec2_1f(g_pacman_Yellow->m_Tile().m_X(),(g_pacman_Yellow->m_Tile().m_Y()+2.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(1)){
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-2.0f),g_pacman_Yellow->m_Tile().m_Y());
    }else if(g_pacman_Yellow->m_Dir==bbInt(3)){
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()+2.0f),g_pacman_Yellow->m_Tile().m_Y());
    }
    t_std_geom_Vec2_1f l_offsetFromRed=t_std_geom_Vec2_1f((g_pacman_Red->m_Tile().m_X()-l_targetTile.m_X()),(g_pacman_Red->m_Tile().m_Y()-l_targetTile.m_Y()));
    l_targetTile.m_X((l_targetTile.m_X()+-l_offsetFromRed.m_X()));
    l_targetTile.m_Y((l_targetTile.m_Y()+-l_offsetFromRed.m_Y()));
    if((l_targetTile.m_X()>=bbFloat(g_pacman_GridWidth))){
      l_targetTile.m_X(bbFloat((g_pacman_GridWidth-1)));
    }
    if((l_targetTile.m_X()<0.0f)){
      l_targetTile.m_X(0.0f);
    }
    if((l_targetTile.m_Y()>=bbFloat(g_pacman_GridHeight))){
      l_targetTile.m_Y(bbFloat((g_pacman_GridHeight-1)));
    }
    if((l_targetTile.m_Y()<0.0f)){
      l_targetTile.m_Y(0.0f);
    }
  }else if(this->m_Mode==bbInt(4)){
    l_targetTile=this->m_ScatterTargetTile;
  }
  return l_targetTile;
}

void mx2_pacman_src_2sprites_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_Sprites=bbGCNew<t_std_collections_Stack_1Tt_pacman_Sprite_2>();
}

bbInit mx2_pacman_src_2sprites_init_v("pacman_src_2sprites",&mx2_pacman_src_2sprites_init);
