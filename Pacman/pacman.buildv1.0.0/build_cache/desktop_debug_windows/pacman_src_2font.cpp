
#include "pacman_src_2font.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2image.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/monkey/monkey.buildv1.0.0/desktop_debug_windows/monkey_types.h"
#include "pacman_src_2images.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_debug_windows/std_geom_2vec2.h"

extern t_std_geom_Vec2_1i g_pacman_DisplayOffset;

// ***** Internal *****

bbGCRootVar<t_pacman_ImageCollection> g_pacman__0font;
bbString g_pacman__0chars;

void g_pacman_DrawFont(t_mojo_graphics_Canvas* l_canvas,bbString l_text,bbInt l_x,bbInt l_y,t_std_graphics_Color l_color){
  bbDBFrame db_f{"DrawFont:Void(canvas:mojo.graphics.Canvas,text:String,x:Int,y:Int,color:std.graphics.Color)","D:/Dev/Monkey/Pacman/src/font.monkey2"};
  bbDBLocal("canvas",&l_canvas);
  bbDBLocal("text",&l_text);
  bbDBLocal("x",&l_x);
  bbDBLocal("y",&l_y);
  bbDBLocal("color",&l_color);
  bbDBStmt(65537);
  l_text=l_text.toUpper();
  bbDBStmt(69633);
  l_canvas->m_Color(l_color);
  bbDBStmt(73729);
  l_canvas->m_BlendMode(0);
  bbDBStmt(86017);
  {
    bbDBLoop db_loop;
    bbInt l_index=bbInt(0);
    bbDBLocal("index",&l_index);
    bbDBStmt(86017);
    for(;(l_index<l_text.length());l_index+=1){
      bbDBBlock db_blk;
      bbDBStmt(90120);
      bbInt l_char=g_pacman__0chars.find(l_text.mid(l_index,1),bbInt(0));
      bbDBLocal("char",&l_char);
      bbDBStmt(94210);
      if((l_char!=-1)){
        struct f3_t : public bbGCFrame{
          t_mojo_graphics_Image* t0{};
          void gcMark(){
            bbGCMarkPtr(t0);
          }
        }f3{};
        bbDBBlock db_blk;
        bbDBStmt(98307);
        l_canvas->m_DrawImage(f3.t0=g_pacman__0font->m_Item()->at(l_char),bbFloat((g_pacman_DisplayOffset.m_X()+l_x)),bbFloat((g_pacman_DisplayOffset.m_Y()+l_y)));
        bbDBStmt(102403);
        l_x+=8;
      }
    }
  }
}

void g_pacman_InitialiseFont(){
  bbDBFrame db_f{"InitialiseFont:Void()","D:/Dev/Monkey/Pacman/src/font.monkey2"};
  bbDBStmt(45057);
  g_pacman__0font=bbGCNew<t_pacman_ImageCollection>(BB_T("asset::font.png"),8,8,2);
}

void mx2_pacman_src_2font_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman__0chars=BB_T(" ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@.'/-");
}

bbInit mx2_pacman_src_2font_init_v("pacman_src_2font",&mx2_pacman_src_2font_init);
