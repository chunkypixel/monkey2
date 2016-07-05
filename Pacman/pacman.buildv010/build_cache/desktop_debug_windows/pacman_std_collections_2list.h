
#ifndef MX2_PACMAN_STD_COLLECTIONS_2LIST_H
#define MX2_PACMAN_STD_COLLECTIONS_2LIST_H

#include <bbmonkey.h>
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_collections_2list.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/monkey/monkey.buildv010/desktop_debug_windows/monkey_types.h"
#include "pacman_std_collections_2container.h"

struct t_std_collections_Stack_1Tt_pacman_Sprite_2;
bbString bbDBType(t_std_collections_Stack_1Tt_pacman_Sprite_2**);
bbString bbDBValue(t_std_collections_Stack_1Tt_pacman_Sprite_2**);
struct t_pacman_Sprite;
bbString bbDBType(t_pacman_Sprite**);
bbString bbDBValue(t_pacman_Sprite**);

// ***** Internal *****

struct t_std_collections_List_1Tt_pacman_Sprite_2_Node;
struct t_std_collections_List_1Tt_pacman_Sprite_2_Iterator;
struct t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator;
struct t_std_collections_List_1Tt_pacman_Sprite_2;

extern void g_std_collections_List_1Tt_pacman_Sprite_2_AddAll_1Tt_std_collections_List_1Tt_pacman_Sprite_2_2(t_std_collections_List_1Tt_pacman_Sprite_2* l_self,t_std_collections_List_1Tt_pacman_Sprite_2* l_values);
extern void g_std_collections_List_1Tt_pacman_Sprite_2_AddAll_1Tt_std_collections_Stack_1Tt_pacman_Sprite_2_2(t_std_collections_List_1Tt_pacman_Sprite_2* l_self,t_std_collections_Stack_1Tt_pacman_Sprite_2* l_values);

struct t_std_collections_List_1Tt_pacman_Sprite_2_Node : public bbObject{

  const char *typeName()const{return "t_std_collections_List_1Tt_pacman_Sprite_2_Node";}

  bbGCVar<t_std_collections_List_1Tt_pacman_Sprite_2_Node> m__0succ{};
  bbGCVar<t_std_collections_List_1Tt_pacman_Sprite_2_Node> m__0pred{};
  bbGCVar<t_pacman_Sprite> m__0value{};

  void gcMark();
  void dbEmit();

  t_std_collections_List_1Tt_pacman_Sprite_2_Node(t_pacman_Sprite* l_value,t_std_collections_List_1Tt_pacman_Sprite_2_Node* l_succ);
  t_std_collections_List_1Tt_pacman_Sprite_2_Node(t_pacman_Sprite* l_value);

  void m_Value(t_pacman_Sprite* l_value);
  t_pacman_Sprite* m_Value();
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_Succ();
  void m_Remove();
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_Pred();
  void m_InsertBefore(t_std_collections_List_1Tt_pacman_Sprite_2_Node* l_node);
  void m_InsertAfter(t_std_collections_List_1Tt_pacman_Sprite_2_Node* l_node);

  t_std_collections_List_1Tt_pacman_Sprite_2_Node(){
  }
};
bbString bbDBType(t_std_collections_List_1Tt_pacman_Sprite_2_Node**);
bbString bbDBValue(t_std_collections_List_1Tt_pacman_Sprite_2_Node**);

struct t_std_collections_List_1Tt_pacman_Sprite_2_Iterator{
  const char *typeName()const{return "t_std_collections_List_1Tt_pacman_Sprite_2_Iterator";}

  bbGCVar<t_std_collections_List_1Tt_pacman_Sprite_2> m__0list{};
  bbGCVar<t_std_collections_List_1Tt_pacman_Sprite_2_Node> m__0node{};
  bbInt m__0seq{};
  static void dbEmit(t_std_collections_List_1Tt_pacman_Sprite_2_Iterator*);

  t_std_collections_List_1Tt_pacman_Sprite_2_Iterator(t_std_collections_List_1Tt_pacman_Sprite_2* l_list,t_std_collections_List_1Tt_pacman_Sprite_2_Node* l_node);

  void m_Insert(t_pacman_Sprite* l_value);
  void m_Erase();
  void m_Current(t_pacman_Sprite* l_current);
  t_pacman_Sprite* m_Current();
  void m_Bump();
  bbBool m_AtEnd();
  void m_AssertSeq();
  void m_AssertCurrent();

  t_std_collections_List_1Tt_pacman_Sprite_2_Iterator(){
  }

  t_std_collections_List_1Tt_pacman_Sprite_2_Iterator(bbNullCtor_t){
  }
};
bbString bbDBType(t_std_collections_List_1Tt_pacman_Sprite_2_Iterator*);
bbString bbDBValue(t_std_collections_List_1Tt_pacman_Sprite_2_Iterator*);

int bbCompare(const t_std_collections_List_1Tt_pacman_Sprite_2_Iterator&x,const t_std_collections_List_1Tt_pacman_Sprite_2_Iterator&y);

void bbGCMark(const t_std_collections_List_1Tt_pacman_Sprite_2_Iterator&);

struct t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator{
  const char *typeName()const{return "t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator";}

  bbGCVar<t_std_collections_List_1Tt_pacman_Sprite_2> m__0list{};
  bbGCVar<t_std_collections_List_1Tt_pacman_Sprite_2_Node> m__0node{};
  bbInt m__0seq{};
  static void dbEmit(t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator*);

  t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator(t_std_collections_List_1Tt_pacman_Sprite_2* l_list,t_std_collections_List_1Tt_pacman_Sprite_2_Node* l_node);

  void m_Insert(t_pacman_Sprite* l_value);
  void m_Erase();
  void m_Current(t_pacman_Sprite* l_current);
  t_pacman_Sprite* m_Current();
  void m_Bump();
  bbBool m_AtEnd();
  void m_AssertSeq();
  void m_AssertCurrent();

  t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator(){
  }

  t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator(bbNullCtor_t){
  }
};
bbString bbDBType(t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator*);
bbString bbDBValue(t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator*);

int bbCompare(const t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator&x,const t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator&y);

void bbGCMark(const t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator&);

struct t_std_collections_List_1Tt_pacman_Sprite_2 : public bbObject,public virtual t_std_collections_IContainer_1Tt_pacman_Sprite_2{

  const char *typeName()const{return "t_std_collections_List_1Tt_pacman_Sprite_2";}

  bbGCVar<t_std_collections_List_1Tt_pacman_Sprite_2_Node> m__0head{};
  bbInt m__0seq{};

  void gcMark();
  void dbEmit();

  t_std_collections_List_1Tt_pacman_Sprite_2(t_std_collections_List_1Tt_pacman_Sprite_2* l_values);
  t_std_collections_List_1Tt_pacman_Sprite_2(t_std_collections_Stack_1Tt_pacman_Sprite_2* l_values);
  t_std_collections_List_1Tt_pacman_Sprite_2(bbArray<bbGCVar<t_pacman_Sprite>>* l_values);
  t_std_collections_List_1Tt_pacman_Sprite_2();

  bbArray<bbGCVar<t_pacman_Sprite>>* m_ToArray();
  void m_Sort(bbFunction<bbInt(t_pacman_Sprite*,t_pacman_Sprite*)> l_compareFunc);
  void m_Sort(bbBool l_ascending);
  t_pacman_Sprite* m_RemoveLast();
  bbBool m_RemoveLast(t_pacman_Sprite* l_value);
  t_pacman_Sprite* m_RemoveFirst();
  bbInt m_RemoveEach(t_pacman_Sprite* l_value);
  bbBool m_Remove(t_pacman_Sprite* l_value);
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_LastNode();
  t_pacman_Sprite* m_Last();
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_HeadNode();
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_FirstNode();
  t_pacman_Sprite* m_First();
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_FindNode(t_pacman_Sprite* l_value);
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_FindLastNode(t_pacman_Sprite* l_value);
  bbBool m_Empty();
  bbInt m_Count();
  void m_Clear();
  t_std_collections_List_1Tt_pacman_Sprite_2_BackwardsIterator m_Backwards();
  t_std_collections_List_1Tt_pacman_Sprite_2_Iterator m_All();
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_AddLast(t_pacman_Sprite* l_value);
  t_std_collections_List_1Tt_pacman_Sprite_2_Node* m_AddFirst(t_pacman_Sprite* l_value);
  void m_AddAll(bbArray<bbGCVar<t_pacman_Sprite>>* l_values);
  void m_Add(t_pacman_Sprite* l_value);
};
bbString bbDBType(t_std_collections_List_1Tt_pacman_Sprite_2**);
bbString bbDBValue(t_std_collections_List_1Tt_pacman_Sprite_2**);

#endif
