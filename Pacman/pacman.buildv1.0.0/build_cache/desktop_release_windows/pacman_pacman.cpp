
#include "pacman_pacman.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_app_2app.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_app_2event.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_input_2mouse.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_release_windows/std_graphics_2color.h"

extern void g_pacman_InitialiseSprites();
extern void g_pacman_InitialiseGrid();
extern void g_pacman_InitialiseFont();
extern void g_std_random_SeedRnd(bbULong l_seed);
extern void g_pacman_UpdateSprites();
extern void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_DrawFont(t_mojo_graphics_Canvas* l_canvas,bbString l_text,bbInt l_x,bbInt l_y,t_std_graphics_Color l_color);
extern void g_pacman_SetGhostMode(bbInt l_mode);
extern void g_pacman_SetGhostReverseDirection();

// ***** Internal *****

bbGCRootVar<t_pacman_PacmanWindow> g_pacman_window;
t_std_geom_Vec2_1i g_pacman_DisplayOffset;

void bbMain(){
  static bool done;
  if(done) return;
  done=true;
  void mx2_mojo_main();mx2_mojo_main();
  void mx2_std_main();mx2_std_main();
  bbGCNew<t_mojo_app_AppInstance>();
  g_pacman_window=bbGCNew<t_pacman_PacmanWindow>(BB_T("Pacman"),640,480,8);
  g_mojo_app_App->m_Run();
}

t_pacman_PacmanWindow::t_pacman_PacmanWindow(bbString l_title,bbInt l_width,bbInt l_height,bbInt l_flags):t_mojo_app_Window(l_title,l_width,l_height,l_flags){
  this->m_ClearColor(g_std_graphics_Color_Black);
  g_mojo_input_Mouse->m_PointerVisible(false);
  g_pacman_InitialiseSprites();
  g_pacman_InitialiseGrid();
  g_pacman_InitialiseFont();
  g_std_random_SeedRnd(12345678);
}

void t_pacman_PacmanWindow::m_OnWindowEvent(t_mojo_app_WindowEvent* l_event){
  bbInt l_0=l_event->m_Type();
  if(l_0==11){
  }else if(l_0==12){
    g_mojo_app_App->m_RequestRender();
  }else if(l_0==13){
    this->m_IsSuspended=false;
  }else if(l_0==14){
    this->m_IsSuspended=true;
  }else{
    t_mojo_app_Window::m_OnWindowEvent(l_event);
  }
}

void t_pacman_PacmanWindow::m_OnRender(t_mojo_graphics_Canvas* l_canvas){
  g_pacman_UpdateSprites();
  g_mojo_app_App->m_RequestRender();
  g_pacman_RenderGrid(l_canvas);
  g_pacman_RenderSprites(l_canvas);
  l_canvas->m_Color(g_std_graphics_Color_White);
  if(this->m_ShowFPS){
    g_pacman_DrawFont(l_canvas,(BB_T("FPS-")+bbString(g_mojo_app_App->m_FPS())),bbInt(0),bbInt(0),g_std_graphics_Color_White);
  }
}

void t_pacman_PacmanWindow::m_OnKeyEvent(t_mojo_app_KeyEvent* l_event){
  bbInt l_0=l_event->m_Type();
  if(l_0==0){
    bbInt l_1=l_event->m_Key();
    if(l_1==197){
      this->m_Fullscreen(!this->m_Fullscreen());
    }else if(l_1==27){
      g_mojo_app_App->m_Terminate();
    }else if(l_1==102){
      this->m_ShowFPS=!this->m_ShowFPS;
    }else if(l_1==100){
      this->m_IsDebug=!this->m_IsDebug;
    }else if(l_1==186){
      g_pacman_SetGhostMode(bbInt(3));
    }else if(l_1==187){
      g_pacman_SetGhostMode(bbInt(4));
    }else if(l_1==188){
      g_pacman_SetGhostMode(bbInt(5));
    }else if(l_1==109){
      this->m_MoveGhosts=!this->m_MoveGhosts;
    }else if(l_1==114){
      g_pacman_SetGhostReverseDirection();
    }
  }
}

void mx2_pacman_pacman_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_DisplayOffset=t_std_geom_Vec2_1i(32,bbInt(0));
}

bbInit mx2_pacman_pacman_init_v("pacman_pacman",&mx2_pacman_pacman_init);
