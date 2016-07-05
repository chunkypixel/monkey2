
#include "pacman_src_2grid.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2image.h"
#include "pacman_pacman.h"
#include "pacman_src_2images.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_release_windows/std_geom_2vec2.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_release_windows/std_graphics_2color.h"

// ***** Internal *****

bbInt g_pacman_GridWidth;
bbInt g_pacman_GridHeight;
bbGCRootVar<bbArray<bbInt,2>> g_pacman_Grid;
bbGCRootVar<t_pacman_ImageCollection> g_pacman_GridBlocks;

void g_pacman_TransferToGrid(bbArray<bbInt>* l_layout){
  bbInt l_index=bbInt(0);
  {
    bbInt l_y=bbInt(0);
    for(;(l_y<g_pacman_GridHeight);l_y+=1){
      {
        bbInt l_x=bbInt(0);
        for(;(l_x<g_pacman_GridWidth);l_x+=1){
          g_pacman_Grid->at(l_x,l_y)=l_layout->at(l_index);
          l_index+=1;
        }
      }
    }
  }
}

void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas){
  l_canvas->m_Color(g_std_graphics_Color_LightGrey);
  {
    bbInt l_y=bbInt(0);
    for(;(l_y<g_pacman_GridHeight);l_y+=1){
      {
        bbInt l_x=bbInt(0);
        for(;(l_x<g_pacman_GridWidth);l_x+=1){
          if((g_pacman_Grid->at(l_x,l_y)>bbInt(0))){
            struct f5_t : public bbGCFrame{
              t_mojo_graphics_Image* t0{};
              void gcMark(){
                bbGCMarkPtr(t0);
              }
            }f5{};
            l_canvas->m_DrawImage(f5.t0=g_pacman_GridBlocks->m_Item()->at(g_pacman_Grid->at(l_x,l_y)),bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))));
          }
        }
      }
    }
  }
  if(g_pacman_window->m_IsDebug){
    l_canvas->m_Color(g_std_graphics_Color_DarkGrey);
    {
      bbInt l_y=bbInt(0);
      for(;(l_y<=g_pacman_GridHeight);l_y+=1){
        l_canvas->m_DrawLine(bbFloat(g_pacman_DisplayOffset.m_X()),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))),bbFloat((g_pacman_DisplayOffset.m_X()+(g_pacman_GridWidth*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(l_y*8))));
      }
    }
    {
      bbInt l_x=bbInt(0);
      for(;(l_x<=g_pacman_GridWidth);l_x+=1){
        l_canvas->m_DrawLine(bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat(g_pacman_DisplayOffset.m_Y()),bbFloat((g_pacman_DisplayOffset.m_X()+(l_x*8))),bbFloat((g_pacman_DisplayOffset.m_Y()+(g_pacman_GridHeight*8))));
      }
    }
  }
}

void g_pacman_InitialiseGrid(){
  struct f0_t : public bbGCFrame{
    bbArray<bbInt>* l_baseGridLayout{};
    void gcMark(){
      bbGCMarkPtr(l_baseGridLayout);
    }
  }f0{};
  g_pacman_GridBlocks=bbGCNew<t_pacman_ImageCollection>(BB_T("asset::gridblocks.png"),8,8,2);
  f0.l_baseGridLayout=bbArray<bbInt>::create({bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),2,11,11,11,11,11,11,11,11,11,11,11,11,40,39,11,11,11,11,11,11,11,11,11,11,11,11,1,4,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,4,bbInt(0),20,13,13,19,bbInt(0),20,13,13,13,19,bbInt(0),22,21,bbInt(0),20,13,13,13,19,bbInt(0),20,13,13,19,bbInt(0),3,4,bbInt(0),22,bbInt(0),bbInt(0),21,bbInt(0),22,bbInt(0),bbInt(0),bbInt(0),21,bbInt(0),22,21,bbInt(0),22,bbInt(0),bbInt(0),bbInt(0),21,bbInt(0),22,bbInt(0),bbInt(0),21,bbInt(0),3,4,bbInt(0),24,18,18,23,bbInt(0),24,18,18,18,23,bbInt(0),24,23,bbInt(0),24,18,18,18,23,bbInt(0),24,18,18,23,bbInt(0),3,4,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,4,bbInt(0),20,13,13,19,bbInt(0),20,19,bbInt(0),20,13,13,13,13,13,13,19,bbInt(0),20,19,bbInt(0),20,13,13,19,bbInt(0),3,4,bbInt(0),24,18,18,23,bbInt(0),22,21,bbInt(0),24,18,18,32,31,18,18,23,bbInt(0),22,21,bbInt(0),24,18,18,23,bbInt(0),3,4,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,6,12,12,12,12,19,bbInt(0),22,33,13,13,19,bbInt(0),22,21,bbInt(0),20,13,13,34,21,bbInt(0),20,12,12,12,12,5,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),22,31,18,18,23,bbInt(0),24,23,bbInt(0),24,18,18,32,21,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),22,21,bbInt(0),26,12,30,41,41,29,12,25,bbInt(0),22,21,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),11,11,11,11,11,23,bbInt(0),24,23,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),24,23,bbInt(0),24,11,11,11,11,11,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),12,12,12,12,12,19,bbInt(0),20,19,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),20,19,bbInt(0),20,12,12,12,12,12,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),22,21,bbInt(0),28,11,11,11,11,11,11,27,bbInt(0),22,21,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),4,bbInt(0),22,21,bbInt(0),20,13,13,13,13,13,13,19,bbInt(0),22,21,bbInt(0),3,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),2,11,11,11,11,23,bbInt(0),24,23,bbInt(0),24,18,18,32,31,18,18,23,bbInt(0),24,23,bbInt(0),24,11,11,11,11,1,4,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,4,bbInt(0),20,13,13,19,bbInt(0),20,13,13,13,19,bbInt(0),22,21,bbInt(0),20,13,13,13,19,bbInt(0),20,13,13,19,bbInt(0),3,4,bbInt(0),24,18,32,21,bbInt(0),24,18,18,18,23,bbInt(0),24,23,bbInt(0),24,18,18,18,23,bbInt(0),22,31,18,23,bbInt(0),3,4,bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),3,8,13,19,bbInt(0),22,21,bbInt(0),20,19,bbInt(0),20,13,13,13,13,13,13,19,bbInt(0),20,19,bbInt(0),22,21,bbInt(0),20,13,7,10,18,23,bbInt(0),24,23,bbInt(0),22,21,bbInt(0),24,18,18,32,31,18,18,23,bbInt(0),22,21,bbInt(0),24,23,bbInt(0),24,18,9,4,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),22,21,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,4,bbInt(0),20,13,13,13,13,34,33,13,13,19,bbInt(0),22,21,bbInt(0),20,13,13,34,33,13,13,13,13,19,bbInt(0),3,4,bbInt(0),24,18,18,18,18,18,18,18,18,23,bbInt(0),24,23,bbInt(0),24,18,18,18,18,18,18,18,18,23,bbInt(0),3,4,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),3,6,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,5,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0)},1008);
  g_pacman_TransferToGrid(f0.l_baseGridLayout);
}

void mx2_pacman_src_2grid_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_GridWidth=28;
  g_pacman_GridHeight=36;
  g_pacman_Grid=bbArray<bbInt,2>::create(g_pacman_GridWidth,g_pacman_GridHeight);
}

bbInit mx2_pacman_src_2grid_init_v("pacman_src_2grid",&mx2_pacman_src_2grid_init);
