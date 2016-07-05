
#include "pacman_pacman.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_release_windows/mojo_app_2app.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_release_windows/mojo_app_2event.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_release_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_release_windows/mojo_input_2mouse.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_release_windows/std_graphics_2color.h"

extern void g_pacman_InitialiseSprites();
extern void g_pacman_InitialiseGrid();
extern void g_pacman_UpdateSprites();
extern void g_pacman_RenderSprites(t_mojo_graphics_Canvas* l_canvas);

// ***** Internal *****

bbGCRootVar<t_pacman_PacmanWindow> g_pacman_window;

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
  l_canvas->m_Scale(2.0f,2.0f);
  g_mojo_app_App->m_RequestRender();
  g_pacman_RenderSprites(l_canvas);
  if(this->m_ShowFPS){
    l_canvas->m_DrawText((BB_T("FPS:")+bbString(g_mojo_app_App->m_FPS())),0.0f,0.0f,0.0f,0.0f);
  }
}

void t_pacman_PacmanWindow::m_OnKeyEvent(t_mojo_app_KeyEvent* l_event){
  bbInt l_0=l_event->m_Type();
  if(l_0==0){
    bbInt l_1=l_event->m_Key();
    if(l_1==140){
      this->m_Fullscreen(!this->m_Fullscreen());
    }else if(l_1==27){
      g_mojo_app_App->m_Terminate();
    }else if(l_1==102){
      this->m_ShowFPS=!this->m_ShowFPS;
    }
  }
}

void mx2_pacman_pacman_init(){
  static bool done;
  if(done) return;
  done=true;
}

bbInit mx2_pacman_pacman_init_v("pacman_pacman",&mx2_pacman_pacman_init);
