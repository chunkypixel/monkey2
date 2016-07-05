
#include "pacman_src_2sprites.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2image.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_input_2keyboard.h"
#include "pacman_pacman.h"
#include "pacman_src_2images.h"
#include "pacman_std_collections_2stack.h"

extern bbGCRootVar<bbArray<bbInt,3>> g_pacman_Grid;
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
  bbDBFrame db_f{"SetSpriteSpeed:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(413697);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(413697);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      struct f2_t : public bbGCFrame{
        t_pacman_Sprite* t0{};
        void gcMark(){
          bbGCMarkPtr(t0);
        }
      }f2{};
      bbDBBlock db_blk;
      bbDBStmt(417794);
      (f2.t0=g_pacman_Sprites->m__idx(l_i))->m_SetSpeed();
    }
  }
}

void g_pacman_SetGhostReverseDirection(){
  bbDBFrame db_f{"SetGhostReverseDirection:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(364545);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(364545);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      struct f2_t : public bbGCFrame{
        t_pacman_GhostSprite* l_ghost{};
        void gcMark(){
          bbGCMarkPtr(l_ghost);
        }
      }f2{};
      bbDBBlock db_blk;
      bbDBStmt(368648);
      f2.l_ghost=bb_object_cast<t_pacman_GhostSprite*>(g_pacman_Sprites->m__idx(l_i));
      bbDBLocal("ghost",&f2.l_ghost);
      bbDBStmt(372738);
      if((f2.l_ghost!=((t_pacman_GhostSprite*)0))){
        bbDBBlock db_blk;
        bbDBStmt(376835);
        if(f2.l_ghost->m_Mode==bbInt(4)||f2.l_ghost->m_Mode==bbInt(5)){
          bbDBBlock db_blk;
          bbDBStmt(385029);
          f2.l_ghost->m_ReverseDirection=true;
        }
      }
    }
  }
}

void g_pacman_SetGhostMode(bbInt l_mode){
  bbDBFrame db_f{"SetGhostMode:Void(mode:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("mode",&l_mode);
  bbDBStmt(331777);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(331777);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      struct f2_t : public bbGCFrame{
        t_pacman_GhostSprite* l_ghost{};
        void gcMark(){
          bbGCMarkPtr(l_ghost);
        }
      }f2{};
      bbDBBlock db_blk;
      bbDBStmt(335880);
      f2.l_ghost=bb_object_cast<t_pacman_GhostSprite*>(g_pacman_Sprites->m__idx(l_i));
      bbDBLocal("ghost",&f2.l_ghost);
      bbDBStmt(339970);
      if(((f2.l_ghost!=((t_pacman_GhostSprite*)0))&&(f2.l_ghost->m_Mode>bbInt(2)))){
        bbDBBlock db_blk;
        bbDBStmt(340022);
        f2.l_ghost->m_Mode=l_mode;
      }
    }
  }
  bbDBStmt(348161);
  g_pacman_SetSpriteSpeed();
}

void g_pacman_ResetSprites(){
  bbDBFrame db_f{"ResetSprites:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(307201);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(307201);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      struct f2_t : public bbGCFrame{
        t_pacman_Sprite* t0{};
        void gcMark(){
          bbGCMarkPtr(t0);
        }
      }f2{};
      bbDBBlock db_blk;
      bbDBStmt(311298);
      (f2.t0=g_pacman_Sprites->m__idx(l_i))->m_Reset();
    }
  }
}

void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"RenderSprites:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(282625);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(282625);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      bbDBBlock db_blk;
      bbDBStmt(286722);
      if(g_pacman_Sprites->m__idx(l_i)->m_Enabled){
        struct f3_t : public bbGCFrame{
          t_pacman_Sprite* t0{};
          void gcMark(){
            bbGCMarkPtr(t0);
          }
        }f3{};
        bbDBBlock db_blk;
        bbDBStmt(286746);
        (f3.t0=g_pacman_Sprites->m__idx(l_i))->m_Render(l_canvas);
      }
    }
  }
}

void g_pacman_UpdateSprites(){
  bbDBFrame db_f{"UpdateSprites:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(258049);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(258049);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      bbDBBlock db_blk;
      bbDBStmt(262146);
      if(g_pacman_Sprites->m__idx(l_i)->m_Enabled){
        struct f3_t : public bbGCFrame{
          t_pacman_Sprite* t0{};
          void gcMark(){
            bbGCMarkPtr(t0);
          }
        }f3{};
        bbDBBlock db_blk;
        bbDBStmt(262170);
        (f3.t0=g_pacman_Sprites->m__idx(l_i))->m_Update();
      }
    }
  }
}

void g_pacman_InitialiseSprites(){
  bbDBFrame db_f{"InitialiseSprites:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(151553);
  g_pacman_Yellow=bbGCNew<t_pacman_PacmanSprite>(BB_T("asset::yellow.png"));
  bbDBStmt(155649);
  g_pacman_Red=bbGCNew<t_pacman_BlinkyGhostSprite>(BB_T("asset::redt.png"),t_std_geom_Vec2_1f(25.0f,0.0f));
  bbDBStmt(159745);
  g_pacman_Pink=bbGCNew<t_pacman_PinkyGhostSprite>(BB_T("asset::pinkt.png"),t_std_geom_Vec2_1f(2.0f,0.0f));
  bbDBStmt(163841);
  g_pacman_Orange=bbGCNew<t_pacman_ClydeGhostSprite>(BB_T("asset::oranget.png"),t_std_geom_Vec2_1f(0.0f,35.0f));
  bbDBStmt(167937);
  g_pacman_Cyan=bbGCNew<t_pacman_InkyGhostSprite>(BB_T("asset::cyant.png"),t_std_geom_Vec2_1f(27.0f,35.0f));
}

void t_pacman_Sprite::init(){
  m_Color=t_std_graphics_Color(1.0f,1.0f,1.0f,1.0f);
  m_Scale=t_std_geom_Vec2_1f(1.0f,1.0f);
}

void t_pacman_Sprite::gcMark(){
  bbGCMark(m_Images);
}

void t_pacman_Sprite::dbEmit(){
  bbDBEmit("X",&m_X);
  bbDBEmit("Y",&m_Y);
  bbDBEmit("Blend",&m_Blend);
  bbDBEmit("Color",&m_Color);
  bbDBEmit("Images",&m_Images);
  bbDBEmit("Frame",&m_Frame);
  bbDBEmit("Rotation",&m_Rotation);
  bbDBEmit("Scale",&m_Scale);
  bbDBEmit("Enabled",&m_Enabled);
  bbDBEmit("Dir",&m_Dir);
  bbDBEmit("PrevDir",&m_PrevDir);
  bbDBEmit("Speed",&m_Speed);
}

t_pacman_Sprite::t_pacman_Sprite(bbString l_image){
  init();
  bbDBFrame db_f{"new:Void(image:String)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBStmt(507906);
  this->m_Images=bbGCNew<t_pacman_ImageCollection>(l_image,16,16,2);
  bbDBStmt(520194);
  g_pacman_Sprites->m_Push(this);
}

t_std_geom_Vec2_1f t_pacman_Sprite::m_Tile(){
  bbDBFrame db_f{"Tile:Vec2f:std.geom.Vec2<Float>()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(536578);
  return t_std_geom_Vec2_1f(bbFloat(bbInt((this->m_X/8.0f))),bbFloat(bbInt((this->m_Y/8.0f))));
}

void t_pacman_Sprite::m_SetPosition(t_std_geom_Vec2_1f l_tile,bbInt l_offsetX,bbInt l_offsetY){
  bbDBFrame db_f{"SetPosition:Void(tile:Vec2f:std.geom.Vec2<Float>,offsetX:Int,offsetY:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("tile",&l_tile);
  bbDBLocal("offsetX",&l_offsetX);
  bbDBLocal("offsetY",&l_offsetY);
  bbDBStmt(843778);
  this->m_X=((l_tile.m_X()*8.0f)+bbFloat(l_offsetX));
  bbDBStmt(847874);
  this->m_Y=((l_tile.m_Y()*8.0f)+bbFloat(l_offsetY));
}

void t_pacman_Sprite::m_SetPosition(bbInt l_x,bbInt l_y,bbInt l_offsetX,bbInt l_offsetY){
  bbDBFrame db_f{"SetPosition:Void(x:Int,y:Int,offsetX:Int,offsetY:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("x",&l_x);
  bbDBLocal("y",&l_y);
  bbDBLocal("offsetX",&l_offsetX);
  bbDBLocal("offsetY",&l_offsetY);
  bbDBStmt(827394);
  this->m_SetPosition(t_std_geom_Vec2_1f(bbFloat(l_x),bbFloat(l_y)),l_offsetX,l_offsetY);
}

void t_pacman_Sprite::m_SetDirection(bbInt l_dir){
  bbDBFrame db_f{"SetDirection:Void(dir:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("dir",&l_dir);
  bbDBStmt(864258);
  this->m_PrevDir=this->m_Dir;
  bbDBStmt(868354);
  this->m_Dir=l_dir;
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,t_std_geom_Vec2_1f l_position,bbBool l_flip){
  struct f0_t : public bbGCFrame{
    t_mojo_graphics_Image* t0{};
    void gcMark(){
      bbGCMarkPtr(t0);
    }
  }f0{};
  bbDBFrame db_f{"Render:Void(canvas:mojo.graphics.Canvas,frame:Int,position:Vec2f:std.geom.Vec2<Float>,flip:Bool)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("canvas",&l_canvas);
  bbDBLocal("frame",&l_frame);
  bbDBLocal("position",&l_position);
  bbDBLocal("flip",&l_flip);
  bbDBStmt(630792);
  t_std_geom_Vec2_1f l_scale=this->m_Scale;
  bbDBLocal("scale",&l_scale);
  bbDBStmt(643074);
  if((l_frame==-1)){
    bbDBBlock db_blk;
    bbDBStmt(643088);
    l_frame=this->m_Frame;
  }
  bbDBStmt(647170);
  if(l_flip){
    bbDBBlock db_blk;
    bbDBStmt(647180);
    l_scale=t_std_geom_Vec2_1f(bbFloat(-1),1.0f);
  }
  bbDBStmt(659458);
  l_canvas->m_BlendMode(this->m_Blend);
  bbDBStmt(663554);
  l_canvas->m_Color(this->m_Color);
  bbDBStmt(667650);
  l_canvas->m_DrawImage(f0.t0=this->m_Images->m_Item()->at(l_frame),l_position,this->m_Rotation,l_scale);
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"Render:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(581634);
  if(g_pacman_window->m_IsDebug){
    bbDBBlock db_blk;
    bbDBStmt(585731);
    l_canvas->m_Color(g_std_graphics_Color_Green);
    bbDBStmt(589827);
    l_canvas->m_DrawRect(bbFloat((g_pacman_DisplayOffset.m_X()+bbInt((this->m_Tile().m_X()*8.0f)))),bbFloat((g_pacman_DisplayOffset.m_Y()+bbInt((this->m_Tile().m_Y()*8.0f)))),8.0f,8.0f);
  }
  bbDBStmt(606210);
  l_canvas->m_Color(g_std_graphics_Color_White);
  bbDBStmt(610306);
  this->m_Render(l_canvas,this->m_Dir,t_std_geom_Vec2_1f(bbFloat(((g_pacman_DisplayOffset.m_X()+bbInt(this->m_X))-8)),bbFloat(((g_pacman_DisplayOffset.m_Y()+bbInt(this->m_Y))-8))),false);
}

bbBool t_pacman_Sprite::m_IsCentreTile(bbFloat l_x,bbFloat l_y,bbInt l_xOffset){
  bbDBFrame db_f{"IsCentreTile:Bool(x:Float,y:Float,xOffset:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("x",&l_x);
  bbDBLocal("y",&l_y);
  bbDBLocal("xOffset",&l_xOffset);
  bbDBStmt(884738);
  return (((bbInt(l_x)%8)==l_xOffset)&&((bbInt(l_y)%8)==4));
}

bbInt t_pacman_Sprite::m_GetNewDirection(t_std_geom_Vec2_1f l_tile){
  bbDBFrame db_f{"GetNewDirection:Int(tile:Vec2f:std.geom.Vec2<Float>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("tile",&l_tile);
  bbDBStmt(905218);
  if((((g_pacman_Grid->at(bbInt(0),bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-1.0f)))==bbInt(0))&&(this->m_Dir!=bbInt(2)))&&(this->m_PrevDir!=bbInt(2)))){
    bbDBBlock db_blk;
    bbDBStmt(909315);
    return bbInt(0);
  }else if(bbDBStmt(913410),(((g_pacman_Grid->at(bbInt(0),bbInt((l_tile.m_X()-1.0f)),bbInt(l_tile.m_Y()))==bbInt(0))&&(this->m_Dir!=bbInt(3)))&&(this->m_PrevDir!=bbInt(3)))){
    bbDBBlock db_blk;
    bbDBStmt(917507);
    return bbInt(1);
  }else if(bbDBStmt(921602),(((g_pacman_Grid->at(bbInt(0),bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+1.0f)))==bbInt(0))&&(this->m_Dir!=bbInt(0)))&&(this->m_PrevDir!=bbInt(0)))){
    bbDBBlock db_blk;
    bbDBStmt(925699);
    return bbInt(2);
  }
  bbDBStmt(933890);
  return bbInt(3);
}

bbBool t_pacman_Sprite::m_CanMoveDirection(t_std_geom_Vec2_1f l_tile,bbInt l_moveDir){
  bbDBFrame db_f{"CanMoveDirection:Bool(tile:Vec2f:std.geom.Vec2<Float>,moveDir:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_Sprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("tile",&l_tile);
  bbDBLocal("moveDir",&l_moveDir);
  bbDBStmt(954370);
  if(l_moveDir==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(962564);
    if(((l_tile.m_Y()-1.0f)>=0.0f)){
      bbDBBlock db_blk;
      bbDBStmt(962581);
      return (g_pacman_Grid->at(bbInt(0),bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-1.0f)))==bbInt(0));
    }
  }else if(l_moveDir==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(970756);
    if(((l_tile.m_Y()+1.0f)<bbFloat(g_pacman_GridHeight))){
      bbDBBlock db_blk;
      bbDBStmt(970781);
      return (g_pacman_Grid->at(bbInt(0),bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+1.0f)))==bbInt(0));
    }
  }else if(l_moveDir==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(978948);
    if(((l_tile.m_X()-1.0f)>=0.0f)){
      bbDBBlock db_blk;
      bbDBStmt(978965);
      return (g_pacman_Grid->at(bbInt(0),bbInt((l_tile.m_X()-1.0f)),bbInt(l_tile.m_Y()))==bbInt(0));
    }
  }else if(l_moveDir==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(987140);
    if(((l_tile.m_X()+1.0f)<bbFloat(g_pacman_GridWidth))){
      bbDBBlock db_blk;
      bbDBStmt(987164);
      return (g_pacman_Grid->at(bbInt(0),bbInt((l_tile.m_X()+1.0f)),bbInt(l_tile.m_Y()))==bbInt(0));
    }
  }
  bbDBStmt(995330);
  return false;
}
bbString bbDBType(t_pacman_Sprite**){
  return "pacman.Sprite";
}
bbString bbDBValue(t_pacman_Sprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_PacmanSprite::dbEmit(){
  t_pacman_Sprite::dbEmit();
  bbDBEmit("Score",&m_Score);
}

t_pacman_PacmanSprite::t_pacman_PacmanSprite(bbString l_image):t_pacman_Sprite(l_image){
  bbDBFrame db_f{"new:Void(image:String)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBStmt(2744322);
  this->m_Reset();
}

void t_pacman_PacmanSprite::m_Update(){
  bbDBFrame db_f{"Update:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_PacmanSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2793480);
  bbBool l_isCentreTile=this->m_IsCentreTile(this->m_X,this->m_Y,4);
  bbDBLocal("isCentreTile",&l_isCentreTile);
  bbDBStmt(2797576);
  t_std_geom_Vec2_1f l_currentTile=this->m_Tile();
  bbDBLocal("currentTile",&l_currentTile);
  bbDBStmt(2809858);
  if(((l_isCentreTile&&(l_currentTile.m_X()>=bbFloat((g_pacman_GridWidth-1))))&&(this->m_Dir==bbInt(3)))){
    bbDBBlock db_blk;
    bbDBStmt(2809936);
    this->m_SetPosition(bbInt(0),bbInt(l_currentTile.m_Y()),bbInt(0),4);
  }
  bbDBStmt(2813954);
  if(((l_isCentreTile&&(l_currentTile.m_X()<=0.0f))&&(this->m_Dir==bbInt(1)))){
    bbDBBlock db_blk;
    bbDBStmt(2814021);
    this->m_SetPosition((g_pacman_GridWidth-1),bbInt(l_currentTile.m_Y()),7,4);
  }
  bbDBStmt(2826248);
  bbBool l_isKeyUp=g_mojo_input_Keyboard->m_KeyDown(210);
  bbDBLocal("isKeyUp",&l_isKeyUp);
  bbDBStmt(2830344);
  bbBool l_isKeyDown=g_mojo_input_Keyboard->m_KeyDown(209);
  bbDBLocal("isKeyDown",&l_isKeyDown);
  bbDBStmt(2834440);
  bbBool l_isKeyLeft=g_mojo_input_Keyboard->m_KeyDown(208);
  bbDBLocal("isKeyLeft",&l_isKeyLeft);
  bbDBStmt(2838536);
  bbBool l_isKeyRight=g_mojo_input_Keyboard->m_KeyDown(207);
  bbDBLocal("isKeyRight",&l_isKeyRight);
  bbDBStmt(2842632);
  bbBool l_isKeysPressed=(((l_isKeyUp||l_isKeyDown)||l_isKeyLeft)||l_isKeyRight);
  bbDBLocal("isKeysPressed",&l_isKeysPressed);
  bbDBStmt(2854914);
  if(((!l_isKeysPressed&&l_isCentreTile)&&!this->m_CanMoveDirection(l_currentTile,this->m_Dir))){
    bbDBBlock db_blk;
    bbDBStmt(2855006);
    return;
  }
  bbDBStmt(2867208);
  bbFloat l_moveX=this->m_X;
  bbDBLocal("moveX",&l_moveX);
  bbDBStmt(2871304);
  bbFloat l_moveY=this->m_Y;
  bbDBLocal("moveY",&l_moveY);
  bbDBStmt(2883586);
  if((g_pacman_Grid->at(2,bbInt(l_currentTile.m_X()),bbInt(l_currentTile.m_Y()))==1)){
    bbDBBlock db_blk;
    bbDBStmt(2891779);
    g_pacman_Grid->at(2,bbInt(l_currentTile.m_X()),bbInt(l_currentTile.m_Y()))=bbInt(0);
    bbDBStmt(2895875);
    this->m_Score+=10;
    bbDBStmt(2908163);
    return;
  }
  bbDBStmt(2924546);
  if(l_isKeyDown){
    bbDBBlock db_blk;
    bbDBStmt(2928649);
    bbBool l_canContinueDown=this->m_CanMoveDirection(l_currentTile,bbInt(2));
    bbDBLocal("canContinueDown",&l_canContinueDown);
    bbDBStmt(2932739);
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(0)))&&l_canContinueDown)){
      bbDBBlock db_blk;
      bbDBStmt(2940932);
      this->m_SetDirection(bbInt(2));
    }else if(bbDBStmt(2945027),(l_isCentreTile&&l_canContinueDown)){
      bbDBBlock db_blk;
      bbDBStmt(2953220);
      this->m_SetDirection(bbInt(2));
    }
  }else if(bbDBStmt(2961410),l_isKeyUp){
    bbDBBlock db_blk;
    bbDBStmt(2965513);
    bbBool l_canContinueUp=this->m_CanMoveDirection(l_currentTile,bbInt(0));
    bbDBLocal("canContinueUp",&l_canContinueUp);
    bbDBStmt(2969603);
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(2)))&&l_canContinueUp)){
      bbDBBlock db_blk;
      bbDBStmt(2977796);
      this->m_SetDirection(bbInt(0));
    }else if(bbDBStmt(2981891),(l_isCentreTile&&l_canContinueUp)){
      bbDBBlock db_blk;
      bbDBStmt(2990084);
      this->m_SetDirection(bbInt(0));
    }
  }else if(bbDBStmt(2998274),l_isKeyLeft){
    bbDBBlock db_blk;
    bbDBStmt(3002377);
    bbBool l_canContinueLeft=this->m_CanMoveDirection(l_currentTile,bbInt(1));
    bbDBLocal("canContinueLeft",&l_canContinueLeft);
    bbDBStmt(3006467);
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(3)))&&l_canContinueLeft)){
      bbDBBlock db_blk;
      bbDBStmt(3014660);
      this->m_SetDirection(bbInt(1));
    }else if(bbDBStmt(3018755),(l_isCentreTile&&l_canContinueLeft)){
      bbDBBlock db_blk;
      bbDBStmt(3026948);
      this->m_SetDirection(bbInt(1));
    }
  }else if(bbDBStmt(3035138),l_isKeyRight){
    bbDBBlock db_blk;
    bbDBStmt(3039241);
    bbBool l_canContinueRight=this->m_CanMoveDirection(l_currentTile,bbInt(3));
    bbDBLocal("canContinueRight",&l_canContinueRight);
    bbDBStmt(3043331);
    if(((!l_isCentreTile&&(this->m_Dir==bbInt(1)))&&l_canContinueRight)){
      bbDBBlock db_blk;
      bbDBStmt(3051524);
      this->m_SetDirection(bbInt(3));
    }else if(bbDBStmt(3055619),(l_isCentreTile&&l_canContinueRight)){
      bbDBBlock db_blk;
      bbDBStmt(3063812);
      this->m_SetDirection(bbInt(3));
    }
  }
  bbDBStmt(3084290);
  if(((l_isKeysPressed&&l_isCentreTile)&&!this->m_CanMoveDirection(l_currentTile,this->m_Dir))){
    bbDBBlock db_blk;
    bbDBStmt(3084378);
    return;
  }
  bbDBStmt(3096578);
  if(this->m_Dir==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(3104772);
    l_moveY-=this->m_Speed;
  }else if(this->m_Dir==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(3112964);
    l_moveX-=this->m_Speed;
  }else if(this->m_Dir==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(3121156);
    l_moveY+=this->m_Speed;
  }else if(this->m_Dir==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(3129348);
    l_moveX+=this->m_Speed;
  }
  bbDBStmt(3145730);
  this->m_X=l_moveX;
  bbDBStmt(3149826);
  this->m_Y=l_moveY;
}

void t_pacman_PacmanSprite::m_SetSpeed(){
  bbDBFrame db_f{"SetSpeed:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_PacmanSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(3170306);
  this->m_Speed=0.80f;
}

void t_pacman_PacmanSprite::m_Reset(){
  bbDBFrame db_f{"Reset:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_PacmanSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2760706);
  this->m_SetPosition(14,26,bbInt(0),4);
  bbDBStmt(2764802);
  this->m_SetDirection(bbInt(1));
  bbDBStmt(2768898);
  this->m_SetSpeed();
  bbDBStmt(2772994);
  this->m_Score=bbInt(0);
}
bbString bbDBType(t_pacman_PacmanSprite**){
  return "pacman.PacmanSprite";
}
bbString bbDBValue(t_pacman_PacmanSprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_GhostSprite::init(){
  m_ScatterTargetTile=t_std_geom_Vec2_1f(0.0f,0.0f);
}

void t_pacman_GhostSprite::dbEmit(){
  t_pacman_Sprite::dbEmit();
  bbDBEmit("ScatterTargetTile",&m_ScatterTargetTile);
  bbDBEmit("Mode",&m_Mode);
  bbDBEmit("ReverseDirection",&m_ReverseDirection);
  bbDBEmit("ExitPenDir",&m_ExitPenDir);
  bbDBEmit("DotCounter",&m_DotCounter);
  bbDBEmit("ReleaseOnDot",&m_ReleaseOnDot);
  bbDBEmit("DotCounterActive",&m_DotCounterActive);
}

t_pacman_GhostSprite::t_pacman_GhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_Sprite(l_image){
  init();
  bbDBFrame db_f{"new:Void(image:String,scatterTargetTile:Vec2f:std.geom.Vec2<Float>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("scatterTargetTile",&l_scatterTargetTile);
  bbDBStmt(1060866);
  this->m_ScatterTargetTile=l_scatterTargetTile;
}

void t_pacman_GhostSprite::m_Update(){
  bbDBFrame db_f{"Update:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_GhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(1093634);
  if(!g_pacman_window->m_MoveGhosts){
    bbDBBlock db_blk;
    bbDBStmt(1093661);
    return;
  }
  bbDBStmt(1105928);
  bbFloat l_moveX=this->m_X;
  bbDBLocal("moveX",&l_moveX);
  bbDBStmt(1110024);
  bbFloat l_moveY=this->m_Y;
  bbDBLocal("moveY",&l_moveY);
  bbDBStmt(1122312);
  bbInt l_xTileOffset=4;
  bbDBLocal("xTileOffset",&l_xTileOffset);
  bbDBStmt(1126402);
  if(this->m_Mode==bbInt(0)||this->m_Mode==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(1134596);
    l_xTileOffset=bbInt(0);
  }
  bbDBStmt(1150978);
  this->m_SetSpeed();
  bbDBStmt(1155074);
  if(this->m_Dir==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(1163268);
    l_moveY-=this->m_Speed;
  }else if(this->m_Dir==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(1171460);
    l_moveX-=this->m_Speed;
  }else if(this->m_Dir==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(1179652);
    l_moveY+=this->m_Speed;
  }else if(this->m_Dir==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(1187844);
    l_moveX+=this->m_Speed;
  }
  bbDBStmt(1204232);
  bbBool l_isCentreTile=this->m_IsCentreTile(l_moveX,l_moveY,l_xTileOffset);
  bbDBLocal("isCentreTile",&l_isCentreTile);
  bbDBStmt(1220610);
  if((this->m_ReverseDirection&&l_isCentreTile)){
    bbDBBlock db_blk;
    bbDBStmt(1228809);
    bbInt l_reverseDir=((this->m_Dir+2)%4);
    bbDBLocal("reverseDir",&l_reverseDir);
    bbDBStmt(1241091);
    if(!this->m_CanMoveDirection(this->m_Tile(),l_reverseDir)){
      bbDBBlock db_blk;
      bbDBStmt(1241139);
      l_reverseDir=((this->m_PrevDir+2)%4);
    }
    bbDBStmt(1253379);
    this->m_SetDirection(l_reverseDir);
    bbDBStmt(1257475);
    this->m_ReverseDirection=false;
  }
  bbDBStmt(1273858);
  if(((l_isCentreTile&&(this->m_Tile().m_X()>=bbFloat((g_pacman_GridWidth-1))))&&(this->m_Dir==bbInt(3)))){
    bbDBBlock db_blk;
    bbDBStmt(1277955);
    this->m_SetPosition(bbInt(0),bbInt(this->m_Tile().m_Y()),bbInt(0),4);
    bbDBStmt(1282051);
    l_moveX=this->m_X;
    bbDBStmt(1286147);
    l_moveY=this->m_Y;
  }else if(bbDBStmt(1290242),((l_isCentreTile&&(this->m_Tile().m_X()<=0.0f))&&(this->m_Dir==bbInt(1)))){
    bbDBBlock db_blk;
    bbDBStmt(1294339);
    this->m_SetPosition((g_pacman_GridWidth-1),bbInt(this->m_Tile().m_Y()),7,4);
    bbDBStmt(1298435);
    l_moveX=this->m_X;
    bbDBStmt(1302531);
    l_moveY=this->m_Y;
  }
  bbDBStmt(1318920);
  t_std_geom_Vec2_1f l_nextTile=t_std_geom_Vec2_1f(bbFloat(bbInt((l_moveX/8.0f))),bbFloat(bbInt((l_moveY/8.0f))));
  bbDBLocal("nextTile",&l_nextTile);
  bbDBStmt(1331202);
  if(this->m_Mode==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(1343495);
    if(!this->m_CanMoveDirection(l_nextTile,this->m_Dir)){
      bbDBBlock db_blk;
      bbDBStmt(1343540);
      this->m_Dir=((this->m_Dir+2)%4);
    }
    bbDBStmt(1355780);
    if((l_isCentreTile&&(this->m_DotCounter>=this->m_ReleaseOnDot))){
      bbDBBlock db_blk;
      bbDBStmt(1363973);
      this->m_Dir=bbInt(0);
      bbDBStmt(1368069);
      if((this->m_Tile().m_X()<14.0f)){
        bbDBBlock db_blk;
        bbDBStmt(1368089);
        this->m_Dir=bbInt(3);
      }
      bbDBStmt(1372165);
      if((this->m_Tile().m_X()>14.0f)){
        bbDBBlock db_blk;
        bbDBStmt(1372185);
        this->m_Dir=bbInt(1);
      }
      bbDBStmt(1376261);
      this->m_Mode=bbInt(1);
    }
  }else if(this->m_Mode==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(1400836);
    if((l_isCentreTile&&(this->m_Tile().m_X()==14.0f))){
      bbDBBlock db_blk;
      bbDBStmt(1404933);
      if((this->m_Tile().m_Y()>14.0f)){
        bbDBBlock db_blk;
        bbDBStmt(1413126);
        this->m_Dir=bbInt(0);
      }else{
        bbDBStmt(1417221);
        bbDBBlock db_blk;
        bbDBStmt(1429510);
        this->m_Dir=this->m_ExitPenDir;
        bbDBStmt(1433606);
        this->m_Mode=bbInt(4);
      }
    }
  }else{
    bbDBBlock db_blk;
    bbDBStmt(1462276);
    if(this->m_IsCentreTile(l_moveX,l_moveY,l_xTileOffset)){
      bbDBBlock db_blk;
      bbDBStmt(1470469);
      if(this->m_Mode==bbInt(4)||this->m_Mode==bbInt(5)||this->m_Mode==bbInt(2)){
        bbDBBlock db_blk;
        bbDBStmt(1482765);
        t_std_geom_Vec2_1f l_targetTile=this->m_GetTargetTile();
        bbDBLocal("targetTile",&l_targetTile);
        bbDBStmt(1499149);
        bbInt l_oppositeDir=((this->m_Dir+2)%4);
        bbDBLocal("oppositeDir",&l_oppositeDir);
        bbDBStmt(1503245);
        bbInt l_oppositePrevDir=((this->m_PrevDir+2)%4);
        bbDBLocal("oppositePrevDir",&l_oppositePrevDir);
        bbDBStmt(1515533);
        bbInt l_targetDir=-1;
        bbDBLocal("targetDir",&l_targetDir);
        bbDBStmt(1519629);
        bbInt l_targetDistance=-1;
        bbDBLocal("targetDistance",&l_targetDistance);
        bbDBStmt(1523719);
        {
          bbDBLoop db_loop;
          bbInt l_dir=bbInt(0);
          bbDBLocal("dir",&l_dir);
          bbDBStmt(1523719);
          for(;(l_dir<=3);l_dir+=1){
            bbDBBlock db_blk;
            bbDBStmt(1531918);
            bbInt l_checkTargetDistance=this->m_FindTargetDistance(l_nextTile,l_targetTile,l_dir);
            bbDBLocal("checkTargetDistance",&l_checkTargetDistance);
            bbDBStmt(1536008);
            if(((((l_checkTargetDistance>=bbInt(0))&&((l_checkTargetDistance<l_targetDistance)||(l_targetDistance<bbInt(0))))&&(l_dir!=l_oppositeDir))&&(l_dir!=l_oppositePrevDir))){
              bbDBBlock db_blk;
              bbDBStmt(1540105);
              l_targetDistance=l_checkTargetDistance;
              bbDBStmt(1544201);
              l_targetDir=l_dir;
            }
          }
        }
        bbDBStmt(1564679);
        this->m_SetDirection(l_targetDir);
      }else if(this->m_Mode==bbInt(6)){
        bbDBBlock db_blk;
        bbDBStmt(1601543);
        this->m_SetDirection(this->m_GetNewDirection(l_nextTile));
      }
    }
  }
  bbDBStmt(1638402);
  this->m_X=l_moveX;
  bbDBStmt(1642498);
  this->m_Y=l_moveY;
}

void t_pacman_GhostSprite::m_SetSpeed(){
  bbDBFrame db_f{"SetSpeed:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_GhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(1736706);
  if(this->m_Mode==bbInt(0)||this->m_Mode==bbInt(1)||this->m_Mode==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(1744900);
    this->m_Speed=0.50f;
  }else if(this->m_Mode==bbInt(6)){
    bbDBBlock db_blk;
    bbDBStmt(1753092);
    this->m_Speed=0.50f;
  }else{
    bbDBBlock db_blk;
    bbDBStmt(1761284);
    this->m_Speed=0.75f;
  }
  bbDBStmt(1777666);
  if((g_pacman_Grid->at(1,bbInt(this->m_Tile().m_X()),bbInt(this->m_Tile().m_Y()))==1)){
    bbDBBlock db_blk;
    bbDBStmt(1777705);
    this->m_Speed=0.40f;
  }
}

void t_pacman_GhostSprite::m_Render(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"Render:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_GhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(1662978);
  t_pacman_Sprite::m_Render(l_canvas);
  bbDBStmt(1675266);
  if(g_pacman_window->m_IsDebug){
    bbDBBlock db_blk;
    bbDBStmt(1683459);
    if(this->m_Mode==bbInt(4)||this->m_Mode==bbInt(5)){
      bbDBBlock db_blk;
      bbDBStmt(1695755);
      t_std_geom_Vec2_1f l_targetTile=this->m_GetTargetTile();
      bbDBLocal("targetTile",&l_targetTile);
      bbDBStmt(1699845);
      l_canvas->m_Color(g_std_graphics_Color_Green);
      bbDBStmt(1703941);
      l_canvas->m_DrawLine(((bbFloat(g_pacman_DisplayOffset.m_X())+(this->m_Tile().m_X()*8.0f))+4.0f),((bbFloat(g_pacman_DisplayOffset.m_Y())+(this->m_Tile().m_Y()*8.0f))+4.0f),((bbFloat(g_pacman_DisplayOffset.m_X())+(l_targetTile.m_X()*8.0f))+4.0f),((bbFloat(g_pacman_DisplayOffset.m_Y())+(l_targetTile.m_Y()*8.0f))+4.0f));
    }
  }
}

bbInt t_pacman_GhostSprite::m_GetDistanceToTarget(bbInt l_x1,bbInt l_y1,bbInt l_x2,bbInt l_y2){
  bbDBFrame db_f{"GetDistanceToTarget:Int(x1:Int,y1:Int,x2:Int,y2:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_GhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("x1",&l_x1);
  bbDBLocal("y1",&l_y1);
  bbDBLocal("x2",&l_x2);
  bbDBLocal("y2",&l_y2);
  bbDBStmt(1925122);
  return (((l_x2-l_x1)*(l_x2-l_x1))+((l_y2-l_y1)*(l_y2-l_y1)));
}

bbInt t_pacman_GhostSprite::m_FindTargetDistance(t_std_geom_Vec2_1f l_tile,t_std_geom_Vec2_1f l_targetTile,bbInt l_dirToTarget){
  bbDBFrame db_f{"FindTargetDistance:Int(tile:Vec2f:std.geom.Vec2<Float>,targetTile:Vec2f:std.geom.Vec2<Float>,dirToTarget:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_GhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("tile",&l_tile);
  bbDBLocal("targetTile",&l_targetTile);
  bbDBLocal("dirToTarget",&l_dirToTarget);
  bbDBStmt(1802248);
  bbBool l_canMoveUp=true;
  bbDBLocal("canMoveUp",&l_canMoveUp);
  bbDBStmt(1806338);
  if(this->m_Mode==bbInt(4)||this->m_Mode==bbInt(5)){
    bbDBBlock db_blk;
    bbDBStmt(1814532);
    if((g_pacman_Grid->at(1,bbInt(l_tile.m_X()),bbInt(l_tile.m_Y()))==2)){
      bbDBBlock db_blk;
      bbDBStmt(1814561);
      l_canMoveUp=false;
    }
  }
  bbDBStmt(1830914);
  if(l_dirToTarget==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(1839108);
    if((((l_tile.m_Y()>0.0f)&&(g_pacman_Grid->at(bbInt(0),bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-1.0f)))==bbInt(0)))&&l_canMoveUp)){
      bbDBBlock db_blk;
      bbDBStmt(1843205);
      return this->m_GetDistanceToTarget(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()-2.0f)),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }else if(l_dirToTarget==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(1855492);
    if(((l_tile.m_Y()<bbFloat((g_pacman_GridHeight-1)))&&(g_pacman_Grid->at(bbInt(0),bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+1.0f)))==bbInt(0)))){
      bbDBBlock db_blk;
      bbDBStmt(1859589);
      return this->m_GetDistanceToTarget(bbInt(l_tile.m_X()),bbInt((l_tile.m_Y()+2.0f)),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }else if(l_dirToTarget==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(1871876);
    if(((l_tile.m_X()>0.0f)&&(g_pacman_Grid->at(bbInt(0),bbInt((l_tile.m_X()-1.0f)),bbInt(l_tile.m_Y()))==bbInt(0)))){
      bbDBBlock db_blk;
      bbDBStmt(1875973);
      return this->m_GetDistanceToTarget(bbInt((l_tile.m_X()-2.0f)),bbInt(l_tile.m_Y()),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }else if(l_dirToTarget==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(1888260);
    if(((l_tile.m_X()<bbFloat((g_pacman_GridWidth-1)))&&(g_pacman_Grid->at(bbInt(0),bbInt((l_tile.m_X()+1.0f)),bbInt(l_tile.m_Y()))==bbInt(0)))){
      bbDBBlock db_blk;
      bbDBStmt(1892357);
      return this->m_GetDistanceToTarget(bbInt((l_tile.m_X()+2.0f)),bbInt(l_tile.m_Y()),bbInt(l_targetTile.m_X()),bbInt(l_targetTile.m_Y()));
    }
  }
  bbDBStmt(1904642);
  return -1;
}
bbString bbDBType(t_pacman_GhostSprite**){
  return "pacman.GhostSprite";
}
bbString bbDBValue(t_pacman_GhostSprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_BlinkyGhostSprite::dbEmit(){
  t_pacman_GhostSprite::dbEmit();
}

t_pacman_BlinkyGhostSprite::t_pacman_BlinkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
  bbDBFrame db_f{"new:Void(image:String,scatterTargetTile:Vec2f:std.geom.Vec2<Float>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("scatterTargetTile",&l_scatterTargetTile);
  bbDBStmt(1966082);
  this->m_Reset();
}

void t_pacman_BlinkyGhostSprite::m_Reset(){
  bbDBFrame db_f{"Reset:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_BlinkyGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2031618);
  this->m_SetPosition(14,14,bbInt(0),4);
  bbDBStmt(2035714);
  this->m_SetDirection(bbInt(1));
  bbDBStmt(2039810);
  this->m_Mode=bbInt(4);
  bbDBStmt(2043906);
  this->m_SetSpeed();
  bbDBStmt(2048002);
  this->m_DotCounter=bbInt(0);
  bbDBStmt(2052098);
  this->m_ReleaseOnDot=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_BlinkyGhostSprite::m_GetTargetTile(){
  bbDBFrame db_f{"GetTargetTile:Vec2f:std.geom.Vec2<Float>()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_BlinkyGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(1982472);
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  bbDBLocal("targetTile",&l_targetTile);
  bbDBStmt(1986562);
  if(this->m_Mode==bbInt(5)){
    bbDBBlock db_blk;
    bbDBStmt(1994756);
    l_targetTile=this->m_ScatterTargetTile;
  }else if(this->m_Mode==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(2007044);
    l_targetTile=t_std_geom_Vec2_1f(14.0f,14.0f);
  }
  bbDBStmt(2015234);
  return l_targetTile;
}
bbString bbDBType(t_pacman_BlinkyGhostSprite**){
  return "pacman.BlinkyGhostSprite";
}
bbString bbDBValue(t_pacman_BlinkyGhostSprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_ClydeGhostSprite::dbEmit(){
  t_pacman_GhostSprite::dbEmit();
}

t_pacman_ClydeGhostSprite::t_pacman_ClydeGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
  bbDBFrame db_f{"new:Void(image:String,scatterTargetTile:Vec2f:std.geom.Vec2<Float>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("scatterTargetTile",&l_scatterTargetTile);
  bbDBStmt(2576386);
  this->m_Reset();
}

void t_pacman_ClydeGhostSprite::m_Reset(){
  bbDBFrame db_f{"Reset:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_ClydeGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2682882);
  this->m_SetPosition(16,17,bbInt(0),4);
  bbDBStmt(2686978);
  this->m_SetDirection(bbInt(0));
  bbDBStmt(2691074);
  this->m_Mode=bbInt(0);
  bbDBStmt(2695170);
  this->m_SetSpeed();
  bbDBStmt(2699266);
  this->m_DotCounter=bbInt(0);
  bbDBStmt(2703362);
  this->m_ReleaseOnDot=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_ClydeGhostSprite::m_GetTargetTile(){
  bbDBFrame db_f{"GetTargetTile:Vec2f:std.geom.Vec2<Float>()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_ClydeGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2596872);
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  bbDBLocal("targetTile",&l_targetTile);
  bbDBStmt(2609154);
  if(this->m_Mode==bbInt(4)){
    bbDBBlock db_blk;
    bbDBStmt(2621450);
    bbInt l_distanceToYellow=this->m_GetDistanceToTarget(bbInt(this->m_Tile().m_X()),bbInt(this->m_Tile().m_Y()),bbInt(g_pacman_Yellow->m_Tile().m_X()),bbInt(g_pacman_Yellow->m_Tile().m_Y()));
    bbDBLocal("distanceToYellow",&l_distanceToYellow);
    bbDBStmt(2625540);
    if((l_distanceToYellow>8)){
      bbDBBlock db_blk;
      bbDBStmt(2625564);
      l_targetTile=this->m_ScatterTargetTile;
    }
  }else if(this->m_Mode==bbInt(5)){
    bbDBBlock db_blk;
    bbDBStmt(2637828);
    l_targetTile=this->m_ScatterTargetTile;
  }else if(this->m_Mode==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(2650116);
    l_targetTile=t_std_geom_Vec2_1f(14.0f,14.0f);
  }
  bbDBStmt(2666498);
  return l_targetTile;
}
bbString bbDBType(t_pacman_ClydeGhostSprite**){
  return "pacman.ClydeGhostSprite";
}
bbString bbDBValue(t_pacman_ClydeGhostSprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_PinkyGhostSprite::dbEmit(){
  t_pacman_GhostSprite::dbEmit();
}

t_pacman_PinkyGhostSprite::t_pacman_PinkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
  bbDBFrame db_f{"new:Void(image:String,scatterTargetTile:Vec2f:std.geom.Vec2<Float>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("scatterTargetTile",&l_scatterTargetTile);
  bbDBStmt(2088962);
  this->m_Reset();
}

void t_pacman_PinkyGhostSprite::m_Reset(){
  bbDBFrame db_f{"Reset:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_PinkyGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2260994);
  this->m_SetPosition(14,17,bbInt(0),4);
  bbDBStmt(2265090);
  this->m_SetDirection(bbInt(2));
  bbDBStmt(2269186);
  this->m_Mode=bbInt(0);
  bbDBStmt(2273282);
  this->m_SetSpeed();
  bbDBStmt(2277378);
  this->m_DotCounter=bbInt(0);
  bbDBStmt(2281474);
  this->m_ReleaseOnDot=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_PinkyGhostSprite::m_GetTargetTile(){
  bbDBFrame db_f{"GetTargetTile:Vec2f:std.geom.Vec2<Float>()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_PinkyGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2109448);
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  bbDBLocal("targetTile",&l_targetTile);
  bbDBStmt(2121730);
  if(this->m_Mode==bbInt(4)){
    bbDBBlock db_blk;
    bbDBStmt(2134020);
    if(g_pacman_Yellow->m_Dir==bbInt(0)){
      bbDBBlock db_blk;
      bbDBStmt(2146310);
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-4.0f),(g_pacman_Yellow->m_Tile().m_Y()-4.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(2)){
      bbDBBlock db_blk;
      bbDBStmt(2158598);
      l_targetTile=t_std_geom_Vec2_1f(g_pacman_Yellow->m_Tile().m_X(),(g_pacman_Yellow->m_Tile().m_Y()+4.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(1)){
      bbDBBlock db_blk;
      bbDBStmt(2166790);
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-4.0f),g_pacman_Yellow->m_Tile().m_Y());
    }else if(g_pacman_Yellow->m_Dir==bbInt(3)){
      bbDBBlock db_blk;
      bbDBStmt(2174982);
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()+4.0f),g_pacman_Yellow->m_Tile().m_Y());
    }
    bbDBStmt(2191364);
    if((l_targetTile.m_X()>=bbFloat(g_pacman_GridWidth))){
      bbDBBlock db_blk;
      bbDBStmt(2191392);
      l_targetTile.m_X(bbFloat((g_pacman_GridWidth-1)));
    }
    bbDBStmt(2195460);
    if((l_targetTile.m_X()<0.0f)){
      bbDBBlock db_blk;
      bbDBStmt(2195479);
      l_targetTile.m_X(0.0f);
    }
    bbDBStmt(2199556);
    if((l_targetTile.m_Y()>=bbFloat(g_pacman_GridHeight))){
      bbDBBlock db_blk;
      bbDBStmt(2199585);
      l_targetTile.m_Y(bbFloat((g_pacman_GridHeight-1)));
    }
    bbDBStmt(2203652);
    if((l_targetTile.m_Y()<0.0f)){
      bbDBBlock db_blk;
      bbDBStmt(2203671);
      l_targetTile.m_Y(0.0f);
    }
  }else if(this->m_Mode==bbInt(5)){
    bbDBBlock db_blk;
    bbDBStmt(2215940);
    l_targetTile=this->m_ScatterTargetTile;
  }else if(this->m_Mode==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(2228228);
    l_targetTile=t_std_geom_Vec2_1f(14.0f,14.0f);
  }
  bbDBStmt(2244610);
  return l_targetTile;
}
bbString bbDBType(t_pacman_PinkyGhostSprite**){
  return "pacman.PinkyGhostSprite";
}
bbString bbDBValue(t_pacman_PinkyGhostSprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_InkyGhostSprite::dbEmit(){
  t_pacman_GhostSprite::dbEmit();
}

t_pacman_InkyGhostSprite::t_pacman_InkyGhostSprite(bbString l_image,t_std_geom_Vec2_1f l_scatterTargetTile):t_pacman_GhostSprite(l_image,l_scatterTargetTile){
  bbDBFrame db_f{"new:Void(image:String,scatterTargetTile:Vec2f:std.geom.Vec2<Float>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("scatterTargetTile",&l_scatterTargetTile);
  bbDBStmt(2318338);
  this->m_Reset();
}

void t_pacman_InkyGhostSprite::m_Reset(){
  bbDBFrame db_f{"Reset:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_InkyGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2514946);
  this->m_SetPosition(12,17,bbInt(0),4);
  bbDBStmt(2519042);
  this->m_SetDirection(bbInt(0));
  bbDBStmt(2523138);
  this->m_Mode=bbInt(0);
  bbDBStmt(2527234);
  this->m_SetSpeed();
  bbDBStmt(2531330);
  this->m_DotCounter=bbInt(0);
  bbDBStmt(2535426);
  this->m_ReleaseOnDot=bbInt(0);
}

t_std_geom_Vec2_1f t_pacman_InkyGhostSprite::m_GetTargetTile(){
  bbDBFrame db_f{"GetTargetTile:Vec2f:std.geom.Vec2<Float>()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  t_pacman_InkyGhostSprite*self=this;
  bbDBLocal("Self",&self);
  bbDBStmt(2338824);
  t_std_geom_Vec2_1f l_targetTile=g_pacman_Yellow->m_Tile();
  bbDBLocal("targetTile",&l_targetTile);
  bbDBStmt(2351106);
  if(this->m_Mode==bbInt(4)){
    bbDBBlock db_blk;
    bbDBStmt(2367492);
    if(g_pacman_Yellow->m_Dir==bbInt(0)){
      bbDBBlock db_blk;
      bbDBStmt(2379782);
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-2.0f),(g_pacman_Yellow->m_Tile().m_Y()-2.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(2)){
      bbDBBlock db_blk;
      bbDBStmt(2392070);
      l_targetTile=t_std_geom_Vec2_1f(g_pacman_Yellow->m_Tile().m_X(),(g_pacman_Yellow->m_Tile().m_Y()+2.0f));
    }else if(g_pacman_Yellow->m_Dir==bbInt(1)){
      bbDBBlock db_blk;
      bbDBStmt(2400262);
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()-2.0f),g_pacman_Yellow->m_Tile().m_Y());
    }else if(g_pacman_Yellow->m_Dir==bbInt(3)){
      bbDBBlock db_blk;
      bbDBStmt(2408454);
      l_targetTile=t_std_geom_Vec2_1f((g_pacman_Yellow->m_Tile().m_X()+2.0f),g_pacman_Yellow->m_Tile().m_Y());
    }
    bbDBStmt(2420746);
    t_std_geom_Vec2_1f l_offsetFromRed=t_std_geom_Vec2_1f((g_pacman_Red->m_Tile().m_X()-l_targetTile.m_X()),(g_pacman_Red->m_Tile().m_Y()-l_targetTile.m_Y()));
    bbDBLocal("offsetFromRed",&l_offsetFromRed);
    bbDBStmt(2428932);
    l_targetTile.m_X((l_targetTile.m_X()+-l_offsetFromRed.m_X()));
    bbDBStmt(2433028);
    l_targetTile.m_Y((l_targetTile.m_Y()+-l_offsetFromRed.m_Y()));
    bbDBStmt(2445316);
    if((l_targetTile.m_X()>=bbFloat(g_pacman_GridWidth))){
      bbDBBlock db_blk;
      bbDBStmt(2445344);
      l_targetTile.m_X(bbFloat((g_pacman_GridWidth-1)));
    }
    bbDBStmt(2449412);
    if((l_targetTile.m_X()<0.0f)){
      bbDBBlock db_blk;
      bbDBStmt(2449431);
      l_targetTile.m_X(0.0f);
    }
    bbDBStmt(2453508);
    if((l_targetTile.m_Y()>=bbFloat(g_pacman_GridHeight))){
      bbDBBlock db_blk;
      bbDBStmt(2453537);
      l_targetTile.m_Y(bbFloat((g_pacman_GridHeight-1)));
    }
    bbDBStmt(2457604);
    if((l_targetTile.m_Y()<0.0f)){
      bbDBBlock db_blk;
      bbDBStmt(2457623);
      l_targetTile.m_Y(0.0f);
    }
  }else if(this->m_Mode==bbInt(5)){
    bbDBBlock db_blk;
    bbDBStmt(2469892);
    l_targetTile=this->m_ScatterTargetTile;
  }else if(this->m_Mode==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(2482180);
    l_targetTile=t_std_geom_Vec2_1f(14.0f,14.0f);
  }
  bbDBStmt(2498562);
  return l_targetTile;
}
bbString bbDBType(t_pacman_InkyGhostSprite**){
  return "pacman.InkyGhostSprite";
}
bbString bbDBValue(t_pacman_InkyGhostSprite**p){
  return bbDBObjectValue(*p);
}

void mx2_pacman_src_2sprites_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_Sprites=bbGCNew<t_std_collections_Stack_1Tt_pacman_Sprite_2>();
}

bbInit mx2_pacman_src_2sprites_init_v("pacman_src_2sprites",&mx2_pacman_src_2sprites_init);
