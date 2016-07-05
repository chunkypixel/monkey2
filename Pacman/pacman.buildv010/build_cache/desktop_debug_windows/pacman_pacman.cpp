
#include "pacman_pacman.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_app_2app.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_app_2event.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_input_2mouse.h"
#include "pacman_src_2sprites.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_graphics_2color.h"

extern void g_pacman_InitialiseGrid();
extern void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas);

// ***** Internal *****

bbGCRootVar<t_pacman_PacmanWindow> g_pacman_window;
t_std_geom_Vec2_1f g_pacman_DisplayOffset;

void bbMain(){
  static bool done;
  if(done) return;
  done=true;
  void mx2_mojo_main();mx2_mojo_main();
  void mx2_std_main();mx2_std_main();
  bbDBFrame db_f{"Main:Void()","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  bbDBStmt(77825);
  bbGCNew<t_mojo_app_AppInstance>();
  bbDBStmt(81921);
  g_pacman_window=bbGCNew<t_pacman_PacmanWindow>(BB_T("Pacman"),640,480,8);
  bbDBStmt(86017);
  g_mojo_app_App->m_Run();
}

void t_pacman_PacmanWindow::dbEmit(){
  t_mojo_app_Window::dbEmit();
  bbDBEmit("IsPaused",&m_IsPaused);
  bbDBEmit("IsSuspended",&m_IsSuspended);
  bbDBEmit("ShowFPS",&m_ShowFPS);
}

t_pacman_PacmanWindow::t_pacman_PacmanWindow(bbString l_title,bbInt l_width,bbInt l_height,bbInt l_flags):t_mojo_app_Window(l_title,l_width,l_height,l_flags){
  bbDBFrame db_f{"new:Void(title:String,width:Int,height:Int,flags:mojo.app.WindowFlags)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  bbDBLocal("title",&l_title);
  bbDBLocal("width",&l_width);
  bbDBLocal("height",&l_height);
  bbDBLocal("flags",&l_flags);
  bbDBStmt(139266);
  this->m_ClearColor(g_std_graphics_Color_Black);
  bbDBStmt(143362);
  g_mojo_input_Mouse->m_PointerVisible(false);
  bbDBStmt(159746);
  g_pacman_InitialiseSprites();
  bbDBStmt(163842);
  g_pacman_InitialiseGrid();
}

void t_pacman_PacmanWindow::m_OnWindowEvent(t_mojo_app_WindowEvent* l_event){
  bbDBFrame db_f{"OnWindowEvent:Void(event:mojo.app.WindowEvent)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  bbDBLocal("event",&l_event);
  bbInt l_0=l_event->m_Type();
  bbDBLocal("0",&l_0);
  bbDBStmt(319490);
  if(l_0==11){
    bbDBBlock db_blk;
  }else if(l_0==12){
    bbDBBlock db_blk;
    bbDBStmt(331780);
    g_mojo_app_App->m_RequestRender();
  }else if(l_0==13){
    bbDBBlock db_blk;
    bbDBStmt(339972);
    this->m_IsSuspended=false;
  }else if(l_0==14){
    bbDBBlock db_blk;
    bbDBStmt(348164);
    this->m_IsSuspended=true;
  }else{
    bbDBBlock db_blk;
    bbDBStmt(356356);
    t_mojo_app_Window::m_OnWindowEvent(l_event);
  }
}

void t_pacman_PacmanWindow::m_OnRender(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"OnRender:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(188418);
  g_pacman_UpdateSprites();
  bbDBStmt(200706);
  l_canvas->m_Scale(1.5f,1.5f);
  bbDBStmt(212994);
  g_mojo_app_App->m_RequestRender();
  bbDBStmt(217090);
  g_pacman_RenderGrid(l_canvas);
  bbDBStmt(221186);
  g_pacman_RenderSprites(l_canvas);
  bbDBStmt(233474);
  if(this->m_ShowFPS){
    bbDBBlock db_blk;
    bbDBStmt(233487);
    l_canvas->m_DrawText((BB_T("FPS:")+bbString(g_mojo_app_App->m_FPS())),0.0f,0.0f,0.0f,0.0f);
  }
  bbDBStmt(237570);
  l_canvas->m_DrawText(((((BB_T("T[")+bbString(g_pacman_Yellow->m_Tile.m_X()))+BB_T(","))+bbString(g_pacman_Yellow->m_Tile.m_Y()))+BB_T("]")),0.0f,15.0f,0.0f,0.0f);
  bbDBStmt(241666);
  l_canvas->m_DrawText((BB_T("Dir:")+bbString(g_pacman_Yellow->m_Dir)),0.0f,30.0f,0.0f,0.0f);
}

void t_pacman_PacmanWindow::m_OnKeyEvent(t_mojo_app_KeyEvent* l_event){
  bbDBFrame db_f{"OnKeyEvent:Void(event:mojo.app.KeyEvent)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  bbDBLocal("event",&l_event);
  bbInt l_0=l_event->m_Type();
  bbDBLocal("0",&l_0);
  bbDBStmt(262146);
  if(l_0==0){
    bbDBBlock db_blk;
    bbInt l_1=l_event->m_Key();
    bbDBLocal("1",&l_1);
    bbDBStmt(270340);
    if(l_1==140){
      bbDBBlock db_blk;
      bbDBStmt(278534);
      this->m_Fullscreen(!this->m_Fullscreen());
    }else if(l_1==27){
      bbDBBlock db_blk;
      bbDBStmt(286726);
      g_mojo_app_App->m_Terminate();
    }else if(l_1==102){
      bbDBBlock db_blk;
      bbDBStmt(294918);
      this->m_ShowFPS=!this->m_ShowFPS;
    }
  }
}
bbString bbDBType(t_pacman_PacmanWindow**){
  return "pacman.PacmanWindow";
}
bbString bbDBValue(t_pacman_PacmanWindow**p){
  return bbDBObjectValue(*p);
}

void mx2_pacman_pacman_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_DisplayOffset=t_std_geom_Vec2_1f(32.0f,0.0f);
}

bbInit mx2_pacman_pacman_init_v("pacman_pacman",&mx2_pacman_pacman_init);
