
#include "pacman_src_2sprites.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_graphics_2image.h"
#include "pacman_std_collections_2stack.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_geom_2rect.h"

struct t_mojo_graphics_Shader;
bbString bbDBType(t_mojo_graphics_Shader**);
bbString bbDBValue(t_mojo_graphics_Shader**);

extern t_std_geom_Vec2_1f g_pacman_DisplayOffset;
extern bbGCRootVar<bbArray<bbInt,2>> g_pacman_Grid;

// ***** Internal *****

bbGCRootVar<t_std_collections_Stack_1Tt_pacman_Sprite_2> g_pacman_Sprites;
bbGCRootVar<t_pacman_PacmanSprite> g_pacman_Yellow;
bbGCRootVar<t_pacman_GhostSprite> g_pacman_Red;
bbGCRootVar<t_pacman_Sprite> g_pacman_Orange;
bbGCRootVar<t_pacman_Sprite> g_pacman_Pink;
bbGCRootVar<t_pacman_Sprite> g_pacman_Cyan;

void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"RenderSprites:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(229377);
  l_canvas->m_Color(g_std_graphics_Color_White);
  bbDBStmt(237569);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(237569);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      bbDBBlock db_blk;
      bbDBStmt(241666);
      if(g_pacman_Sprites->m__idx(l_i)->m_Enabled){
        struct f3_t : public bbGCFrame{
          t_pacman_Sprite* t0{};
          void gcMark(){
            bbGCMark(t0);
          }
        }f3{};
        bbDBBlock db_blk;
        bbDBStmt(241690);
        (f3.t0=g_pacman_Sprites->m__idx(l_i))->m_Render(l_canvas);
      }
    }
  }
}

void g_pacman_UpdateSprites(){
  bbDBFrame db_f{"UpdateSprites:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(200705);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(200705);
    for(;(l_i<g_pacman_Sprites->m_Length());l_i+=1){
      bbDBBlock db_blk;
      bbDBStmt(204802);
      if(g_pacman_Sprites->m__idx(l_i)->m_Enabled){
        struct f3_t : public bbGCFrame{
          t_pacman_Sprite* t0{};
          void gcMark(){
            bbGCMark(t0);
          }
        }f3{};
        bbDBBlock db_blk;
        bbDBStmt(204826);
        (f3.t0=g_pacman_Sprites->m__idx(l_i))->m_Update();
      }
    }
  }
}

void g_pacman_InitialiseSprites(){
  struct f0_t : public bbGCFrame{
    t_mojo_graphics_Image* t0{};
    void gcMark(){
      bbGCMark(t0);
    }
  }f0{};
  bbDBFrame db_f{"InitialiseSprites:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(131073);
  g_pacman_Yellow=bbGCNew<t_pacman_PacmanSprite>(f0.t0=g_mojo_graphics_Image_Load(BB_T("asset::yellow.png"),2,((t_mojo_graphics_Shader*)0)),16,16);
  bbDBStmt(135169);
  g_pacman_Yellow->m_SetPosition(13,26);
  bbDBStmt(139265);
  g_pacman_Yellow->m_Dir=bbInt(1);
  bbDBStmt(143361);
  g_pacman_Yellow->m_Enabled=true;
  bbDBStmt(147457);
  g_pacman_Red=bbGCNew<t_pacman_GhostSprite>(f0.t0=g_mojo_graphics_Image_Load(BB_T("asset::red.png"),2,((t_mojo_graphics_Shader*)0)),16,16,t_std_geom_Vec2_1i(26,bbInt(0)));
  bbDBStmt(151553);
  g_pacman_Red->m_SetPosition(13,14);
  bbDBStmt(155649);
  g_pacman_Red->m_Dir=bbInt(3);
  bbDBStmt(159745);
  g_pacman_Red->m_Enabled=true;
}

void t_pacman_Sprite::init(){
  m_Tile=t_std_geom_Vec2_1i(bbInt(0),bbInt(0));
  m_tempTile=t_std_geom_Vec2_1i(bbInt(0),bbInt(0));
  m_Color=t_std_graphics_Color(1.0f,1.0f,1.0f,1.0f);
  m_Scale=t_std_geom_Vec2_1f(1.0f,1.0f);
}

void t_pacman_Sprite::gcMark(){
  bbGCMark(m_Images);
}

void t_pacman_Sprite::dbEmit(){
  bbDBEmit("Tile",&m_Tile);
  bbDBEmit("tempTile",&m_tempTile);
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
}

t_pacman_Sprite::t_pacman_Sprite(t_mojo_graphics_Image* l_image,bbInt l_frameWidth,bbInt l_frameHeight){
  init();
  bbDBFrame db_f{"new:Void(image:mojo.graphics.Image,frameWidth:Int,frameHeight:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("frameWidth",&l_frameWidth);
  bbDBLocal("frameHeight",&l_frameHeight);
  bbDBStmt(327688);
  bbFloat l_handleX=bbFloat(((l_frameWidth/2)/l_frameWidth));
  bbDBLocal("handleX",&l_handleX);
  bbDBStmt(331784);
  bbFloat l_handleY=bbFloat(((l_frameHeight/2)/l_frameHeight));
  bbDBLocal("handleY",&l_handleY);
  bbDBStmt(335880);
  bbInt l_frameCount=(l_image->m_Width()/l_frameWidth);
  bbDBLocal("frameCount",&l_frameCount);
  bbDBStmt(339976);
  bbInt l_imageWidth=l_image->m_Width();
  bbDBLocal("imageWidth",&l_imageWidth);
  bbDBStmt(352258);
  this->m_Images=bbArray<bbGCVar<t_mojo_graphics_Image>>::create(l_frameCount);
  bbDBStmt(356354);
  {
    bbDBLoop db_loop;
    bbInt l_i=bbInt(0);
    bbDBLocal("i",&l_i);
    bbDBStmt(356354);
    for(;(l_i<(l_frameCount-1));l_i+=1){
      struct f2_t : public bbGCFrame{
        t_mojo_graphics_Image* l_newImage{};
        void gcMark(){
          bbGCMark(l_newImage);
        }
      }f2{};
      bbDBBlock db_blk;
      bbDBStmt(364553);
      bbInt l_x0=(l_i*l_frameWidth);
      bbDBLocal("x0",&l_x0);
      bbDBStmt(376841);
      f2.l_newImage=bbGCNew<t_mojo_graphics_Image>(l_image,t_std_geom_Rect_1i(l_x0,bbInt(0),(l_x0+l_frameWidth),l_frameHeight));
      bbDBLocal("newImage",&f2.l_newImage);
      bbDBStmt(385027);
      this->m_Images->at(l_i)=f2.l_newImage;
    }
  }
  bbDBStmt(401410);
  g_pacman_Sprites->m_Push(this);
}

void t_pacman_Sprite::m_Update(){
  bbDBFrame db_f{"Update:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(471048);
  bbFloat l_moveX=this->m_X;
  bbDBLocal("moveX",&l_moveX);
  bbDBStmt(475144);
  bbFloat l_moveY=this->m_Y;
  bbDBLocal("moveY",&l_moveY);
  bbDBStmt(487426);
  if(this->m_Dir==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(495620);
    l_moveY-=1.0f;
  }else if(this->m_Dir==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(503812);
    l_moveX-=1.0f;
  }else if(this->m_Dir==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(512004);
    l_moveY+=1.0f;
  }else if(this->m_Dir==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(520196);
    l_moveX+=1.0f;
  }
  bbDBStmt(536578);
  if(this->m_IsCentreTile(l_moveX,l_moveY)){
    bbDBBlock db_blk;
    bbDBStmt(544777);
    t_std_geom_Vec2_1i l_nextTile=t_std_geom_Vec2_1i(bbInt((l_moveX/8.0f)),bbInt((l_moveY/8.0f)));
    bbDBLocal("nextTile",&l_nextTile);
    bbDBStmt(548867);
    this->m_Dir=this->m_GetNewDirection(l_nextTile,this->m_Dir);
    bbDBStmt(561155);
    this->m_Tile=l_nextTile;
  }
  bbDBStmt(577538);
  this->m_X=l_moveX;
  bbDBStmt(581634);
  this->m_Y=l_moveY;
}

void t_pacman_Sprite::m_SetPosition(t_std_geom_Vec2_1i l_tile){
  bbDBFrame db_f{"SetPosition:Void(tile:Vec2i:std.geom.Vec2<Int>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("tile",&l_tile);
  bbDBStmt(434178);
  this->m_Tile=l_tile;
  bbDBStmt(438274);
  this->m_X=bbFloat(((l_tile.m_X()*8)+4));
  bbDBStmt(442370);
  this->m_Y=bbFloat(((l_tile.m_Y()*8)+4));
}

void t_pacman_Sprite::m_SetPosition(bbInt l_x,bbInt l_y){
  bbDBFrame db_f{"SetPosition:Void(x:Int,y:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("x",&l_x);
  bbDBLocal("y",&l_y);
  bbDBStmt(417794);
  this->m_SetPosition(t_std_geom_Vec2_1i(l_x,l_y));
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas,bbInt l_frame,t_std_geom_Vec2_1f l_position,bbBool l_flip){
  bbDBFrame db_f{"Render:Void(canvas:mojo.graphics.Canvas,frame:Int,position:Vec2f:std.geom.Vec2<Float>,flip:Bool)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBLocal("frame",&l_frame);
  bbDBLocal("position",&l_position);
  bbDBLocal("flip",&l_flip);
  bbDBStmt(716808);
  t_std_geom_Vec2_1f l_scale=this->m_Scale;
  bbDBLocal("scale",&l_scale);
  bbDBStmt(729090);
  if((l_frame==-1)){
    bbDBBlock db_blk;
    bbDBStmt(729104);
    l_frame=this->m_Frame;
  }
  bbDBStmt(733186);
  if(l_flip){
    bbDBBlock db_blk;
    bbDBStmt(733196);
    l_scale=t_std_geom_Vec2_1f(bbFloat(-1),1.0f);
  }
  bbDBStmt(745474);
  l_canvas->m_BlendMode(this->m_Blend);
  bbDBStmt(749570);
  l_canvas->m_Color(this->m_Color);
  bbDBStmt(753666);
  l_canvas->m_DrawImage(this->m_Images->at(l_frame),l_position,this->m_Rotation,l_scale);
}

void t_pacman_Sprite::m_Render(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"Render:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(671746);
  l_canvas->m_Color(g_std_graphics_Color_Green);
  bbDBStmt(675842);
  l_canvas->m_DrawRect((g_pacman_DisplayOffset.m_X()+bbFloat((this->m_Tile.m_X()*8))),(g_pacman_DisplayOffset.m_Y()+bbFloat((this->m_Tile.m_Y()*8))),8.0f,8.0f);
  bbDBStmt(688130);
  l_canvas->m_Color(g_std_graphics_Color_White);
  bbDBStmt(692226);
  l_canvas->m_DrawRect((g_pacman_DisplayOffset.m_X()+this->m_X),(g_pacman_DisplayOffset.m_Y()+this->m_Y),1.0f,1.0f);
}

bbBool t_pacman_Sprite::m_IsCentreTile(bbFloat l_x,bbFloat l_y){
  bbDBFrame db_f{"IsCentreTile:Bool(x:Float,y:Float)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("x",&l_x);
  bbDBLocal("y",&l_y);
  bbDBStmt(602114);
  return ((std::fmod(l_x,8.0f)==4.0f)&&(std::fmod(l_y,8.0f)==4.0f));
}

bbInt t_pacman_Sprite::m_GetNewDirection(t_std_geom_Vec2_1i l_tile,bbInt l_currentDir){
  bbDBFrame db_f{"GetNewDirection:Int(tile:Vec2i:std.geom.Vec2<Int>,currentDir:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("tile",&l_tile);
  bbDBLocal("currentDir",&l_currentDir);
  bbDBStmt(622594);
  if(((g_pacman_Grid->at(l_tile.m_X(),(l_tile.m_Y()-1))==bbInt(0))&&(l_currentDir!=bbInt(2)))){
    bbDBBlock db_blk;
    bbDBStmt(626691);
    return bbInt(0);
  }else if(bbDBStmt(630786),((g_pacman_Grid->at((l_tile.m_X()-1),l_tile.m_Y())==bbInt(0))&&(l_currentDir!=bbInt(3)))){
    bbDBBlock db_blk;
    bbDBStmt(634883);
    return bbInt(1);
  }else if(bbDBStmt(638978),((g_pacman_Grid->at(l_tile.m_X(),(l_tile.m_Y()+1))==bbInt(0))&&(l_currentDir!=bbInt(0)))){
    bbDBBlock db_blk;
    bbDBStmt(643075);
    return bbInt(2);
  }
  bbDBStmt(651266);
  return bbInt(3);
}
bbString bbDBType(t_pacman_Sprite**){
  return "pacman.Sprite";
}
bbString bbDBValue(t_pacman_Sprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_PacmanSprite::dbEmit(){
  t_pacman_Sprite::dbEmit();
}

t_pacman_PacmanSprite::t_pacman_PacmanSprite(t_mojo_graphics_Image* l_image,bbInt l_frameWidth,bbInt l_frameHeight):t_pacman_Sprite(l_image,l_frameWidth,l_frameHeight){
  bbDBFrame db_f{"new:Void(image:mojo.graphics.Image,frameWidth:Int,frameHeight:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("frameWidth",&l_frameWidth);
  bbDBLocal("frameHeight",&l_frameHeight);
}

void t_pacman_PacmanSprite::m_Update(){
  bbDBFrame db_f{"Update:Void()","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBStmt(847880);
  bbFloat l_moveX=this->m_X;
  bbDBLocal("moveX",&l_moveX);
  bbDBStmt(851976);
  bbFloat l_moveY=this->m_Y;
  bbDBLocal("moveY",&l_moveY);
  bbDBStmt(864258);
  if(this->m_Dir==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(872452);
    l_moveY-=1.0f;
  }else if(this->m_Dir==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(880644);
    l_moveX-=1.0f;
  }else if(this->m_Dir==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(888836);
    l_moveY+=1.0f;
  }else if(this->m_Dir==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(897028);
    l_moveX+=1.0f;
  }
  bbDBStmt(913410);
  if(this->m_IsCentreTile(l_moveX,l_moveY)){
    bbDBBlock db_blk;
    bbDBStmt(921609);
    t_std_geom_Vec2_1i l_nextTile=t_std_geom_Vec2_1i(bbInt((l_moveX/8.0f)),bbInt((l_moveY/8.0f)));
    bbDBLocal("nextTile",&l_nextTile);
    bbDBStmt(937987);
    this->m_Tile=l_nextTile;
    bbDBStmt(946179);
    if(!this->m_CanContinueDirection(l_nextTile,this->m_Dir)){
      bbDBBlock db_blk;
      bbDBStmt(946228);
      return;
    }
  }
  bbDBStmt(962562);
  this->m_X=l_moveX;
  bbDBStmt(966658);
  this->m_Y=l_moveY;
}

bbBool t_pacman_PacmanSprite::m_CanContinueDirection(t_std_geom_Vec2_1i l_tile,bbInt l_currentDir){
  bbDBFrame db_f{"CanContinueDirection:Bool(tile:Vec2i:std.geom.Vec2<Int>,currentDir:Int)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("tile",&l_tile);
  bbDBLocal("currentDir",&l_currentDir);
  bbDBStmt(987138);
  if(this->m_Dir==bbInt(0)){
    bbDBBlock db_blk;
    bbDBStmt(995332);
    if((g_pacman_Grid->at(l_tile.m_X(),(l_tile.m_Y()-1))==bbInt(0))){
      bbDBBlock db_blk;
      bbDBStmt(995361);
      return true;
    }
  }else if(this->m_Dir==bbInt(1)){
    bbDBBlock db_blk;
    bbDBStmt(1003524);
    if((g_pacman_Grid->at((l_tile.m_X()-1),l_tile.m_Y())==bbInt(0))){
      bbDBBlock db_blk;
      bbDBStmt(1003553);
      return true;
    }
  }else if(this->m_Dir==bbInt(2)){
    bbDBBlock db_blk;
    bbDBStmt(1011716);
    if((g_pacman_Grid->at(l_tile.m_X(),(l_tile.m_Y()+1))==bbInt(0))){
      bbDBBlock db_blk;
      bbDBStmt(1011745);
      return true;
    }
  }else if(this->m_Dir==bbInt(3)){
    bbDBBlock db_blk;
    bbDBStmt(1019908);
    if((g_pacman_Grid->at((l_tile.m_X()+1),l_tile.m_Y())==bbInt(0))){
      bbDBBlock db_blk;
      bbDBStmt(1019937);
      return true;
    }
  }
  bbDBStmt(1032194);
  return false;
}
bbString bbDBType(t_pacman_PacmanSprite**){
  return "pacman.PacmanSprite";
}
bbString bbDBValue(t_pacman_PacmanSprite**p){
  return bbDBObjectValue(*p);
}

void t_pacman_GhostSprite::init(){
  m_ScatterTargetTile=t_std_geom_Vec2_1i(bbInt(0),bbInt(0));
}

void t_pacman_GhostSprite::dbEmit(){
  t_pacman_Sprite::dbEmit();
  bbDBEmit("ScatterTargetTile",&m_ScatterTargetTile);
  bbDBEmit("Mode",&m_Mode);
}

t_pacman_GhostSprite::t_pacman_GhostSprite(t_mojo_graphics_Image* l_image,bbInt l_frameWidth,bbInt l_frameHeight,t_std_geom_Vec2_1i l_scatterTargetTile):t_pacman_Sprite(l_image,l_frameWidth,l_frameHeight){
  init();
  bbDBFrame db_f{"new:Void(image:mojo.graphics.Image,frameWidth:Int,frameHeight:Int,scatterTargetTile:Vec2i:std.geom.Vec2<Int>)","D:/Dev/Monkey/Pacman/src/sprites.monkey2"};
  bbDBLocal("image",&l_image);
  bbDBLocal("frameWidth",&l_frameWidth);
  bbDBLocal("frameHeight",&l_frameHeight);
  bbDBLocal("scatterTargetTile",&l_scatterTargetTile);
  bbDBStmt(794626);
  this->m_ScatterTargetTile=l_scatterTargetTile;
}
bbString bbDBType(t_pacman_GhostSprite**){
  return "pacman.GhostSprite";
}
bbString bbDBValue(t_pacman_GhostSprite**p){
  return bbDBObjectValue(*p);
}

void mx2_pacman_src_2sprites_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_Sprites=bbGCNew<t_std_collections_Stack_1Tt_pacman_Sprite_2>();
}

bbInit mx2_pacman_src_2sprites_init_v("pacman_src_2sprites",&mx2_pacman_src_2sprites_init);
