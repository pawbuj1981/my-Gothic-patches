func void ChangeConversationColor2 (var int npc_color, var int hero_color)
{
    var c_npc npc;

    if (!InfoManager_HasFinished ())
    {
    
	    npc = _^ (MEM_InformationMan.npc);
	    
        if (Hlp_StrCmp (MEM_ReadString (MEM_ReadInt (ESP+4)), npc.name))
        {	
	    hero.name ="Bezimienny";	
				MEM_WriteString (MEM_ReadInt (ESP+4), hero.name);         	
        MEM_WriteInt (MEM_ReadInt (ESP+16), npc_color);
        };

        if (!STR_Len (MEM_ReadString (MEM_ReadInt (ESP+4))))
        {	    
        MEM_WriteInt (MEM_ReadInt (ESP+16), hero_color);
        
        if (!STR_Len (MEM_ReadString (MEM_ReadInt (ESP+4))))
        //&& ((STR_ToInt(MEM_GetModOpt("UPDATE_PACK", "DialogHeroName_enabled"))))//ddoaje imiê hero w dialogu 
		{
		MEM_WriteInt (MEM_ReadInt (ESP+16), hero_color);
				//if ((STR_ToInt(MEM_GetModOpt("UPDATE_PACK", "DialogHeroName_enabled"))))//ddoaje imiê hero w dialogu 
				//{
				hero.name ="Bezimienny";	
				MEM_WriteString (MEM_ReadInt (ESP+4), hero.name); //wystarczy to dopisaæ
				//};
		//MEM_WriteString (MEM_ReadInt (ESP+8), "Coœ.");//kasuje string dialogu 
		//Print (IntToString (hero_color));		
			};
        };
    };    
};
/*
 * Additional focus colors
 */
func int Ninja_ColorFocusVobs_Partymember() {
    return RGBA(128, 255, 255, 255); // Blue
};


/*
 * Source: https://github.com/szapp/Ninja/wiki/Applications-and-Examples
 */
func int Ninja_ColorFocusVobs_GetAIVarSafe(var C_Npc slf, var string AIVarName, var int dflt) {
    var int symb; symb = MEM_GetParserSymbol(AIVarName);
    if (symb) {
        var int idx; idx = MEM_ReadInt(symb+zCParSymbol_content_offset);
        return MEM_ReadStatArr(slf.aivar, idx);
    } else {
        return dflt; // Return default value, e.g. 0
    };
};

var int NINJA_BOX_X;
var int NINJA_BOX_Y;
var int NINJA_BOX_FIX;

func void SetChoiceBoxScale ()
{
   var int ptr; ptr = MEM_ReadInt(MEMINT_oCInformationManager_Address+28);
    
   NINJA_BOX_FIX = STR_ToInt(MEM_GetGothOpt("CHOICE_BOX", "choice_fix"));//1 
    
   if (!MEM_GothOptExists("CHOICE_BOX","choice_x")) {
        // Add INI-entry, if not set
        MEM_SetGothOpt("CHOICE_BOX", "choice_x", "820");
        MEM_SetGothOpt("CHOICE_BOX", "choice_y", "120");
        MEM_SetGothOpt("CHOICE_BOX", "choice_fix", "0");
	 };
    
    
   //if (STR_ToInt(MEM_GetGothOpt("CHOICE_BOX", "choice_fix"))){
	if ((NINJA_BOX_FIX)== 1){   
		
   	MEM_WriteInt (ptr+64, STR_ToInt (MEM_GetGothOpt ("VIDEO", "zVidResFullscreenY"))); //fix skalowanie ucinanych dialogów
    Print_GetScreenSize(); //Pobiera rozdzielczoœæ ekranu 
	    
   	};
   	NINJA_BOX_X = STR_ToInt(MEM_GetGothOpt("CHOICE_BOX", "choice_x"));//820
	NINJA_BOX_Y = STR_ToInt(MEM_GetGothOpt("CHOICE_BOX", "choice_y"));//120	
	
	
   	MEM_WriteInt (ptr+60, NINJA_BOX_X);//os x       
   	MEM_WriteInt (ptr+56, NINJA_BOX_Y);//oœ y 
   	 
   	
};




/*
 * Source: https://github.com/szapp/Ninja/wiki/Applications-and-Examples
 */
 
func int  Ninja_ColorFocusVobs_GetNpcGuild(var C_Npc slf, var string GIL_NAME) {
    var int symb; symb = MEM_GetParserSymbol(GIL_NAME);
    if (symb) {
        var int idx; idx = MEM_ReadInt(symb+zCParSymbol_content_offset);
        return slf.guild == idx;
    } else {
        return FALSE;
    };
};


/*
 * Slightly modified version of LeGo_Focusnames (_Focusnames). Changes marked with comments
 */
func void Ninja_ChoiceBox_UpdateStatus() {
    
	/*
	var int col; col = -1; // Stupid pseudo-locals
    var oCNpc her; her = Hlp_GetNpc(hero);

    if (Hlp_Is_oCNpc(her.focus_vob)) {
        var C_Npc oth; oth = _^(her.focus_vob);
        var int att; att = Npc_GetPermAttitude(oth, hero);                          // Modified by Pawbuj

        var int party; party = Ninja_ColorFocusVobs_GetAIVarSafe(oth, "AIV_PARTYMEMBER", FALSE);
        var int friendly; friendly = ((att == ATT_FRIENDLY || oth.npctype == NPCTYPE_FRIEND)
                                      && (!Ninja_ColorFocusVobs_GetNpcGuild(oth, "GIL_ORCSLAVE")));

        if      (Npc_IsDead(oth))    { col = Focusnames_Color_Neutral();         }  // New by Pawbuj
        else if (party)              { col = Ninja_ColorFocusVobs_Partymember(); }  // New by Pawbuj
        else if (friendly)           { col = Focusnames_Color_Friendly();        }  // New by Pawbuj
        else if (att == ATT_NEUTRAL) { col = Focusnames_Color_Neutral();         }
        else if (att == ATT_ANGRY)   { col = Focusnames_Color_Angry();           }
        else if (att == ATT_HOSTILE) { col = Focusnames_Color_Hostile();         };
    } else if (Hlp_Is_oCMobLockable(her.focus_vob)) {
        // Case for chests, doors and any other lockable mob
        var oCMobLockable lockable; lockable = _^(her.focus_vob);

        if (lockable.bitfield & oCMobLockable_bitfield_locked) { // Check if mob is locked
            if      (STR_Len(lockable.keyInstance)) { col = Focusnames_Color_Hostile();  }  // Need to use a key
            else if (STR_Len(lockable.pickLockStr)) { col = Focusnames_Color_Angry();    }  // Can use lockpick
            else                                    { col = Focusnames_Color_Neutral();  }; // Should never happen
        } else { // Lockable is not locked
            if (Hlp_Is_oCMobContainer(her.focus_vob)) { // Mob is an container
                var oCMobContainer chest; chest = _^(her.focus_vob);
                if (chest.containList_next)         { col = Focusnames_Color_Friendly(); }  // Chest unlocked and has goods
                else                                { col = Focusnames_Color_Neutral();  }; // Chest unlocked but empty
            } else {
                col = Focusnames_Color_Neutral(); // Lockable is unlocked
            };
        };
    } else {
        col = Focusnames_Color_Neutral();
    };

    var int ptr; ptr = MEM_Alloc(4);
    MEM_WriteInt(ptr, col);
    CALL_IntParam(ptr);
    CALL__thiscall(MEM_ReadInt(screen_offset), zCView__SetFontColor);
    MEM_Free(ptr);
    */
    
    SetChoiceBoxScale ();
    ChangeConversationColor2(-1,-1);
};