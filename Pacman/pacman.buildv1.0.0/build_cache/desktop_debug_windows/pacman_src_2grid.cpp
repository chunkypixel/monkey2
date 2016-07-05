
#include "pacman_src_2grid.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2image.h"
#include "pacman_pacman.h"
#include "pacman_src_2images.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_debug_windows/std_geom_2vec2.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_debug_windows/std_graphics_2color.h"

// ***** Internal *****

bbInt g_pacman_GridWidth;
bbInt g_pacman_GridHeight;
bbInt g_pacman_Layers;
bbGCRootVar<bbArray<bbInt,3>> g_pacman_Grid;
bbGCRootVar<t_pacman_ImageCollection> g_pacman_Blocks;

void g_pacman_TransferToGrid(bbInt l_layer,bbArray<bbInt>* l_layout){
  bbDBFrame db_f{"TransferToGrid:Void(layer:Int,layout:Int[])","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBLocal("layer",&l_layer);
  bbDBLocal("layout",&l_layout);
  bbDBStmt(684039);
  bbInt l_index=bbInt(0);
  bbDBLocal("index",&l_index);
  bbDBStmt(696321);
  {
    bbDBLoop db_loop;
    bbInt l_y=bbInt(0);
    bbDBLocal("y",&l_y);
    bbDBStmt(696321);
    for(;(l_y<g_pacman_GridHeight);l_y+=1){
      bbDBBlock db_blk;
      bbDBStmt(700418);
      {
        bbDBLoop db_loop;
        bbInt l_x=bbInt(0);
        bbDBLocal("x",&l_x);
        bbDBStmt(700418);
        for(;(l_x<g_pacman_GridWidth);l_x+=1){
          bbDBBlock db_blk;
          bbDBStmt(704515);
          g_pacman_Grid->at(l_layer,l_x,l_y)=l_layout->at(l_index);
          bbDBStmt(708611);
          l_index+=1;
        }
      }
    }
  }
}

void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"RenderGrid:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(585729);
  l_canvas->m_Color(g_std_graphics_Color_LightGrey);
  bbDBStmt(589825);
  {
    bbDBLoop db_loop;
    bbInt l_y=bbInt(0);
    bbDBLocal("y",&l_y);
    bbDBStmt(589825);
    for(;(l_y<g_pacman_GridHeight);l_y+=1){
      bbDBBlock db_blk;
      bbDBStmt(593922);
      {
        bbDBLoop db_loop;
        bbInt l_x=bbInt(0);
        bbDBLocal("x",&l_x);
        bbDBStmt(593922);
        for(;(l_x<g_pacman_GridWidth);l_x+=1){
          bbDBBlock db_blk;
          bbDBStmt(598019);
          if((g_pacman_Grid->at(bbInt(0),l_x,l_y)>bbInt(0))){
            struct f5_t : public bbGCFrame{
              t_mojo_graphics_Image* t0{};
              void gcMark(){
                bbGCMarkPtr(t0);
              }
            }f5{};
            bbDBBlock db_blk;
            bbDBStmt(598038);
            l_canvas->m_DrawImage(f5.t0=g_pacman_Blocks->m_Item()->at(g_pacman_Grid->at(bbInt(0),l_x,l_y)),bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))));
          }
          bbDBStmt(602115);
          if((g_pacman_window->m_IsDebug&&(g_pacman_Grid->at(1,l_x,l_y)>bbInt(0)))){
            bbDBBlock db_blk;
            bbDBStmt(602153);
            l_canvas->m_DrawRect(bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))),8.0f,8.0f);
          }
          bbDBStmt(606211);
          if((g_pacman_Grid->at(2,l_x,l_y)>bbInt(0))){
            struct f5_t : public bbGCFrame{
              t_mojo_graphics_Image* t0{};
              void gcMark(){
                bbGCMarkPtr(t0);
              }
            }f5{};
            bbDBBlock db_blk;
            bbDBStmt(606230);
            l_canvas->m_DrawImage(f5.t0=g_pacman_Blocks->m_Item()->at(g_pacman_Grid->at(2,l_x,l_y)),bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))));
          }
        }
      }
    }
  }
  bbDBStmt(630785);
  if(g_pacman_window->m_IsDebug){
    bbDBBlock db_blk;
    bbDBStmt(634882);
    l_canvas->m_Color(g_std_graphics_Color_DarkGrey);
    bbDBStmt(638978);
    {
      bbDBLoop db_loop;
      bbInt l_y=bbInt(0);
      bbDBLocal("y",&l_y);
      bbDBStmt(638978);
      for(;(l_y<=g_pacman_GridHeight);l_y+=1){
        bbDBBlock db_blk;
        bbDBStmt(643075);
        l_canvas->m_DrawLine(bbFloat(g_pacman_DisplayOffset.m_X()),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))),bbFloat((g_pacman_DisplayOffset.m_X()+(g_pacman_GridWidth*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))));
      }
    }
    bbDBStmt(651266);
    {
      bbDBLoop db_loop;
      bbInt l_x=bbInt(0);
      bbDBLocal("x",&l_x);
      bbDBStmt(651266);
      for(;(l_x<=g_pacman_GridWidth);l_x+=1){
        bbDBBlock db_blk;
        bbDBStmt(655363);
        l_canvas->m_DrawLine(bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat(g_pacman_DisplayOffset.m_Y()),bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(g_pacman_GridHeight*8))));
      }
    }
  }
}

void g_pacman_InitialisePillGrid(){
  struct f0_t : public bbGCFrame{
    bbArray<bbInt>* l_pillLayout{};
    void gcMark(){
      bbGCMarkPtr(l_pillLayout);
    }
  }f0{};
  bbDBFrame db_f{"InitialisePillGrid:Void()","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBStmt(409607);
  f0.l_pillLayout=bbArray<bbInt>::create({bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,1,1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),3,1,1,bbInt(0),bbInt(0),1,1,1,1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,1,1,1,bbInt(0),bbInt(0),1,1,3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,bbInt(0),bbInt(0),1,1,1,1,1,1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0)},1008);
  bbDBLocal("pillLayout",&f0.l_pillLayout);
  bbDBStmt(565249);
  g_pacman_TransferToGrid(2,f0.l_pillLayout);
}

void g_pacman_InitialiseGrid(){
  struct f0_t : public bbGCFrame{
    bbArray<bbInt>* l_gridLayout{};
    bbArray<bbInt>* l_zoneLayout{};
    void gcMark(){
      bbGCMarkPtr(l_gridLayout);
      bbGCMarkPtr(l_zoneLayout);
    }
  }f0{};
  bbDBFrame db_f{"InitialiseGrid:Void()","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBStmt(61441);
  g_pacman_Blocks=bbGCNew<t_pacman_ImageCollection>(BB_T("asset::blocks.png"),8,8,2);
  bbDBStmt(73735);
  f0.l_gridLayout=bbArray<bbInt>::create({bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),5,14,14,14,14,14,14,14,14,14,14,14,14,43,42,14,14,14,14,14,14,14,14,14,14,14,14,4,7,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),6,7,bbInt(0),23,16,16,22,bbInt(0),23,16,16,16,22,bbInt(0),25,24,bbInt(0),23,16,16,16,22,bbInt(0),23,16,16,22,bbInt(0),6,7,bbInt(0),25,bbInt(0),bbInt(0),24,bbInt(0),25,bbInt(0),bbInt(0),bbInt(0),24,bbInt(0),25,24,bbInt(0),25,bbInt(0),bbInt(0),bbInt(0),24,bbInt(0),25,bbInt(0),bbInt(0),24,bbInt(0),6,7,bbInt(0),27,21,21,26,bbInt(0),27,21,21,21,26,bbInt(0),27,26,bbInt(0),27,21,21,21,26,bbInt(0),27,21,21,26,bbInt(0),6,7,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),6,7,bbInt(0),23,16,16,22,bbInt(0),23,22,bbInt(0),23,16,16,16,16,16,16,22,bbInt(0),23,22,bbInt(0),23,16,16,22,bbInt(0),6,7,bbInt(0),27,21,21,26,bbInt(0),25,24,bbInt(0),27,21,21,35,34,21,21,26,bbInt(0),25,24,bbInt(0),27,21,21,26,bbInt(0),6,7,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),6,9,15,15,15,15,22,bbInt(0),25,36,16,16,22,bbInt(0),25,24,bbInt(0),23,16,16,37,24,bbInt(0),23,15,15,15,15,8,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),25,34,21,21,26,bbInt(0),27,26,bbInt(0),27,21,21,35,24,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),25,24,bbInt(0),29,15,33,44,44,32,15,28,bbInt(0),25,24,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),14,14,14,14,14,26,bbInt(0),27,26,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),27,26,bbInt(0),27,14,14,14,14,14,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),15,15,15,15,15,22,bbInt(0),23,22,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),23,22,bbInt(0),23,15,15,15,15,15,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),25,24,bbInt(0),31,14,14,14,14,14,14,30,bbInt(0),25,24,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),7,bbInt(0),25,24,bbInt(0),23,16,16,16,16,16,16,22,bbInt(0),25,24,bbInt(0),6,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),5,14,14,14,14,26,bbInt(0),27,26,bbInt(0),27,21,21,35,34,21,21,26,bbInt(0),27,26,bbInt(0),27,14,14,14,14,4,7,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),6,7,bbInt(0),23,16,16,22,bbInt(0),23,16,16,16,22,bbInt(0),25,24,bbInt(0),23,16,16,16,22,bbInt(0),23,16,16,22,bbInt(0),6,7,bbInt(0),27,21,35,24,bbInt(0),27,21,21,21,26,bbInt(0),27,26,bbInt(0),27,21,21,21,26,bbInt(0),25,34,21,26,bbInt(0),6,7,bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),6,11,16,22,bbInt(0),25,24,bbInt(0),23,22,bbInt(0),23,16,16,16,16,16,16,22,bbInt(0),23,22,bbInt(0),25,24,bbInt(0),23,16,10,13,21,26,bbInt(0),27,26,bbInt(0),25,24,bbInt(0),27,21,21,35,34,21,21,26,bbInt(0),25,24,bbInt(0),27,26,bbInt(0),27,21,12,7,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),25,24,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),6,7,bbInt(0),23,16,16,16,16,37,36,16,16,22,bbInt(0),25,24,bbInt(0),23,16,16,37,36,16,16,16,16,22,bbInt(0),6,7,bbInt(0),27,21,21,21,21,21,21,21,21,26,bbInt(0),27,26,bbInt(0),27,21,21,21,21,21,21,21,21,26,bbInt(0),6,7,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),6,9,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0)},1008);
  bbDBLocal("gridLayout",&f0.l_gridLayout);
  bbDBStmt(225287);
  f0.l_zoneLayout=bbArray<bbInt>::create({bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),2,2,2,2,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),2,2,2,2,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0)},1008);
  bbDBLocal("zoneLayout",&f0.l_zoneLayout);
  bbDBStmt(380929);
  g_pacman_TransferToGrid(bbInt(0),f0.l_gridLayout);
  bbDBStmt(385025);
  g_pacman_TransferToGrid(1,f0.l_zoneLayout);
  bbDBStmt(389121);
  g_pacman_InitialisePillGrid();
}

void mx2_pacman_src_2grid_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_GridWidth=28;
  g_pacman_GridHeight=36;
  g_pacman_Layers=2;
  g_pacman_Grid=bbArray<bbInt,3>::create((g_pacman_Layers+1),g_pacman_GridWidth,g_pacman_GridHeight);
}

bbInit mx2_pacman_src_2grid_init_v("pacman_src_2grid",&mx2_pacman_src_2grid_init);
