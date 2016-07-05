
#include "pacman_src_2font.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_release_windows/mojo_graphics_2image.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/monkey/monkey.buildv1.0.0/desktop_release_windows/monkey_types.h"
#include "pacman_src_2images.h"

// ***** Internal *****

bbGCRootVar<t_pacman_ImageCollection> g_pacman__0font;
bbString g_pacman__0chars;

void g_pacman_DrawFont(t_mojo_graphics_Canvas* l_canvas,bbString l_text,bbInt l_x,bbInt l_y,t_std_graphics_Color l_color){
  l_text=l_text.toUpper();
  l_canvas->m_Color(l_color);
  l_canvas->m_BlendMode(0);
  {
    bbInt l_index=bbInt(0);
    for(;(l_index<l_text.length());l_index+=1){
      bbInt l_char=g_pacman__0chars.find(l_text.mid(l_index,1),bbInt(0));
      if((l_char!=-1)){
        struct f3_t : public bbGCFrame{
          t_mojo_graphics_Image* t0{};
          void gcMark(){
            bbGCMarkPtr(t0);
          }
        }f3{};
        l_canvas->m_DrawImage(f3.t0=g_pacman__0font->m_Item()->at(l_char),bbFloat(l_x),bbFloat(l_y));
        l_x+=8;
      }
    }
  }
}

void g_pacman_InitialiseFont(){
  g_pacman__0font=bbGCNew<t_pacman_ImageCollection>(BB_T("asset::font.png"),8,8,2);
}

void mx2_pacman_src_2font_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman__0chars=BB_T(" ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@.'/-");
}

bbInit mx2_pacman_src_2font_init_v("pacman_src_2font",&mx2_pacman_src_2font_init);
