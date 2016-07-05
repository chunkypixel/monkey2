
#include "pacman_src_2grid.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_geom_2vec2.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_graphics_2color.h"

extern t_std_geom_Vec2_1f g_pacman_DisplayOffset;

// ***** Internal *****

bbGCRootVar<bbArray<bbInt,2>> g_pacman_Grid;

void g_pacman_TransferToGrid(bbArray<bbInt>* l_layout,bbInt l_width,bbInt l_height){
  bbDBFrame db_f{"TransferToGrid:Void(layout:Int[],width:Int,height:Int)","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBLocal("layout",&l_layout);
  bbDBLocal("width",&l_width);
  bbDBLocal("height",&l_height);
  bbDBStmt(315399);
  bbInt l_index=bbInt(0);
  bbDBLocal("index",&l_index);
  bbDBStmt(327681);
  {
    bbDBLoop db_loop;
    bbInt l_y=bbInt(0);
    bbDBLocal("y",&l_y);
    bbDBStmt(327681);
    for(;(l_y<=(l_height-1));l_y+=1){
      bbDBBlock db_blk;
      bbDBStmt(331778);
      {
        bbDBLoop db_loop;
        bbInt l_x=bbInt(0);
        bbDBLocal("x",&l_x);
        bbDBStmt(331778);
        for(;(l_x<=(l_width-1));l_x+=1){
          bbDBBlock db_blk;
          bbDBStmt(335875);
          g_pacman_Grid->at(l_x,l_y)=l_layout->at(l_index);
          bbDBStmt(339971);
          l_index+=1;
        }
      }
    }
  }
}

void g_pacman_TransferToGrid(bbArray<bbInt>* l_layout){
  bbDBFrame db_f{"TransferToGrid:Void(layout:Int[])","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBLocal("layout",&l_layout);
  bbDBStmt(294913);
  g_pacman_TransferToGrid(l_layout,28,36);
}

void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"RenderGrid:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(212993);
  l_canvas->m_Color(g_std_graphics_Color_LightGrey);
  bbDBStmt(217089);
  {
    bbDBLoop db_loop;
    bbInt l_y=bbInt(0);
    bbDBLocal("y",&l_y);
    bbDBStmt(217089);
    for(;(l_y<=35);l_y+=1){
      bbDBBlock db_blk;
      bbDBStmt(221186);
      {
        bbDBLoop db_loop;
        bbInt l_x=bbInt(0);
        bbDBLocal("x",&l_x);
        bbDBStmt(221186);
        for(;(l_x<=27);l_x+=1){
          bbDBBlock db_blk;
          bbDBStmt(225283);
          if((g_pacman_Grid->at(l_x,l_y)!=bbInt(0))){
            bbDBBlock db_blk;
            bbDBStmt(225301);
            l_canvas->m_DrawRect((g_pacman_DisplayOffset.m_X()+bbFloat((l_x*8))),(g_pacman_DisplayOffset.m_Y()+bbFloat((l_y*8))),8.0f,8.0f);
          }
        }
      }
    }
  }
  bbDBStmt(245761);
  l_canvas->m_Color(g_std_graphics_Color_DarkGrey);
  bbDBStmt(249857);
  {
    bbDBLoop db_loop;
    bbInt l_y=bbInt(0);
    bbDBLocal("y",&l_y);
    bbDBStmt(249857);
    for(;(l_y<=36);l_y+=1){
      bbDBBlock db_blk;
      bbDBStmt(253954);
      l_canvas->m_DrawLine(g_pacman_DisplayOffset.m_X(),(g_pacman_DisplayOffset.m_Y()+bbFloat((l_y*8))),(g_pacman_DisplayOffset.m_X()+224.0f),(g_pacman_DisplayOffset.m_Y()+bbFloat((l_y*8))));
    }
  }
  bbDBStmt(262145);
  {
    bbDBLoop db_loop;
    bbInt l_x=bbInt(0);
    bbDBLocal("x",&l_x);
    bbDBStmt(262145);
    for(;(l_x<=28);l_x+=1){
      bbDBBlock db_blk;
      bbDBStmt(266242);
      l_canvas->m_DrawLine((g_pacman_DisplayOffset.m_X()+bbFloat((l_x*8))),g_pacman_DisplayOffset.m_Y(),(g_pacman_DisplayOffset.m_X()+bbFloat((l_x*8))),(g_pacman_DisplayOffset.m_Y()+288.0f));
    }
  }
}

void g_pacman_InitialiseGrid(){
  struct f0_t : public bbGCFrame{
    bbArray<bbInt>* l_baseGridLayout{};
    void gcMark(){
      bbGCMark(l_baseGridLayout);
    }
  }f0{};
  bbDBFrame db_f{"InitialiseGrid:Void()","D:/Dev/Monkey/Pacman/src/grid.monkey2"};
  bbDBStmt(32775);
  f0.l_baseGridLayout=bbArray<bbInt>::create({bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),1,1,1,1,1,1,1,1,1,1,bbInt(0),1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0),bbInt(0)},1008);
  bbDBLocal("baseGridLayout",&f0.l_baseGridLayout);
  bbDBStmt(188417);
  g_pacman_TransferToGrid(f0.l_baseGridLayout);
}

void mx2_pacman_src_2grid_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_Grid=bbArray<bbInt,2>::create(28,36);
}

bbInit mx2_pacman_src_2grid_init_v("pacman_src_2grid",&mx2_pacman_src_2grid_init);
