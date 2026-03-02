; ====================================================================
; AHK Script: Bloqueio de Tela para Power Automate Desktop (Versão 10.4)
; CORREÇÃO FINAL UNIVERSAL: Cobertura 100% Garantida em Qualquer Tela
; ====================================================================

#Persistent
#SingleInstance Force

; --- Configurações de Arquivo ---
ArquivoSenha := A_ScriptDir "\senha.ini"
SenhaPadrao := "12345"

; Lê a senha do arquivo.
IniRead, SenhaAtual, %ArquivoSenha%, Config, Senha, %SenhaPadrao%

CorFundo := "1A1A1A" ; Cinza escuro elegante
CorTexto := "FFFFFF" ; Branco
CorDestaque := "4CAF50" ; Verde leve
CorCinza := "CCCCCC"
TituloRobo := "RoboEmExecucao_Fantasma"

; --- 1. MONITORES ---
SysGet, MonitorCount, MonitorCount
Modos := "Bloquear todas as telas"
Loop, %MonitorCount%
{
    SysGet, Monitor%A_Index%, Monitor, %A_Index%
    Modos .= "|" . "Bloquear somente monitor " . A_Index
}

; --- 2. GUI PRINCIPAL ---
Gui, 1: New, -Caption +ToolWindow +AlwaysOnTop +LastFound
Gui, 1: Color, %CorFundo%
Gui, 1: Font, s16 c%CorTexto% Bold, Segoe UI

Gui, 1: Add, Text, xm y+20 w400 Center, TELA PROTETORA

Gui, 1: Font, s10 c%CorCinza%
Gui, 1: Add, Text, xm y+5 w400 Center, Escolha o tipo de bloqueio:

Gui, 1: Font, s12 c%CorTexto%
Gui, 1: Add, DropDownList, vModoTamanho w300 Center Choose1, %Modos%

Gui, 1: Add, Text, xm y+20 w400 Center c%CorCinza%, Digite a senha:

Gui, 1: Add, Edit, vSenha w220 h30 Center Password,

Gui, 1: Add, Button, xm y+25 w180 h35 gSubmit Background%CorDestaque% cFFFFFF, Proteger Tela
Gui, 1: Add, Button, xm y+10 w180 h35 gMudarSenha Background303030 cFFFFFF, Mudar senha
Gui, 1: Add, Button, xm y+10 w180 h35 g1GuiClose Background303030 cFFFFFF, Sair

Gui, 1: Font, s9 c%CorCinza%
Gui, 1: Add, Text, xm y+25 w400 Center, Comando de Saida: CTRL + Q

Gui, 1: Show, Center
Return

; ====================================================================
; 3. DESBLOQUEIO E CÁLCULO UNIVERSAL DE TELA
; ====================================================================

Submit:
    Gui, 1: Submit, NoHide

    If (Senha = SenhaAtual)
    {
        ; --- 3.1. CÁLCULO UNIVERSAL DE COORDENADAS E TAMANHO ---
        
        ; Se a opção for Bloquear todas as telas:
        If (ModoTamanho = "Bloquear todas as telas")
        {
            ; Obtém as coordenadas e o tamanho da área de trabalho virtual total.
            ; AHK usa X76/Y77 como canto superior esquerdo da área combinada.
            SysGet, x_coord, 76 
            SysGet, y_coord, 77 
            SysGet, largura_tela, 78 
            SysGet, altura_tela, 79 
        }
        ; Se a opção for Bloquear somente um monitor:
        Else
        {
            StringSplit, Parte, ModoTamanho, %A_Space%
            NumMonitor := Parte4
            
            ; Obtém as coordenadas do monitor específico
            SysGet, Monitor, Monitor, %NumMonitor%
            
            ; Define as variáveis com as dimensões 100% daquele monitor
            x_coord := MonitorLeft
            y_coord := MonitorTop
            largura_tela := MonitorRight - MonitorLeft ; Largura
            altura_tela := MonitorBottom - MonitorTop ; Altura
        }

        Gui, 1: Destroy

        ; --- 3.2. GUI 2 - TELA FANTASMA ---
        Gui, 2: New, -Caption +ToolWindow +AlwaysOnTop +LastFound
        Gui, 2: Color, %CorFundo%
        
        ; Aplica as coordenadas usando as novas variáveis de nome explícito.
        ; Isso força o AHK a usar as coordenadas negativas se necessário (Monitores multi-tela)
        Gui, 2: Show, x%x_coord% y%y_coord% w%largura_tela% h%altura_tela%, %TituloRobo%

        WinSet, Transparent, 254, %TituloRobo%
        WinSet, ExStyle, +0x20, %TituloRobo% ; Torna a tela click-through

        Gui, 2: Font, s20 c%CorDestaque% Bold, Segoe UI
        Gui, 2: Add, Text, xm y+20 w400 Center, PROTEÇÃO ATIVA

        Gui, 2: Font, s12 c%CorCinza%
        Gui, 2: Add, Text, xm y+15 w400 Center, Pressione CTRL + Q para encerrar

    }
    Else
    {
        MsgBox, 48, Senha incorreta, Senha incorreta. Tente novamente.
        GuiControl, 1:, Senha,
    }
Return

; ====================================================================
; 4. GUI DE MUDAR SENHA
; ====================================================================

MudarSenha:
    Gui, 4: New, -Caption +ToolWindow +AlwaysOnTop
    Gui, 4: Color, %CorFundo%
    Gui, 4: Font, s15 c%CorTexto% Bold, Segoe UI

    Gui, 4: Add, Text, xm y+10 w350 Center, TROCAR SENHA

    Gui, 4: Font, s11 c%CorCinza%
    Gui, 4: Add, Text, xm y+10 w350, Senha atual:
    Gui, 4: Add, Edit, vSenhaAntiga w300 h28 Password,

    Gui, 4: Add, Text, xm y+10 w350, Nova senha:
    Gui, 4: Add, Edit, vSenhaNova w300 h28 Password,

    Gui, 4: Add, Text, xm y+10 w350, Confirmar nova senha:
    Gui, 4: Add, Edit, vSenhaConfirma w300 h28 Password,

    Gui, 4: Add, Button, xm y+20 w120 h35 gSalvarNovaSenha Background%CorDestaque% cFFFFFF, Salvar
    Gui, 4: Add, Button, xm y+10 w120 h35 g4GuiClose Background303030 cFFFFFF, Cancelar

    Gui, 4: Show, Center
    Gui, 1: Hide
Return

SalvarNovaSenha:
    Gui, 4: Submit, NoHide

    If (SenhaAntiga <> SenhaAtual) {
        MsgBox, 16, Erro, Senha antiga incorreta.
    }
    Else If (SenhaNova = "") {
        MsgBox, 16, Erro, A nova senha nao pode ser vazia.
    }
    Else If (SenhaNova <> SenhaConfirma) {
        MsgBox, 16, Erro, Senhas nao conferem.
    }
    Else {
        IniWrite, %SenhaNova%, %ArquivoSenha%, Config, Senha
        SenhaAtual := SenhaNova
        MsgBox, 64, Sucesso, Senha alterada com sucesso.
        Gui, 4: Destroy
        Gui, 1: Show
    }
Return

; ====================================================================
; 5. CTRL + Q - ACESSO DE EMERGENCIA
; ====================================================================

^q::
    If WinExist(TituloRobo)
    {
        Gui, 3: New, -Caption +ToolWindow +AlwaysOnTop
        Gui, 3: Color, %CorFundo%
        Gui, 3: Font, s16 c%CorTexto% Bold, Segoe UI

        Gui, 3: Add, Text, xm y+20 w400 Center, DIGITE SUA SENHA PARA ENCERRAR
        Gui, 3: Add, Text, xm y+10 w400 Center, Digite a senha:

        Gui, 3: Add, Edit, vSenha w200 h30 Center Password,
        Gui, 3: Add, Button, xm y+20 w150 h35 gSubmit3 Background%CorDestaque% cFFFFFF, Encerrar

        Gui, 3: Show, Center
    }
Return

Submit3:
    Gui, 3: Submit, NoHide
    If (Senha = SenhaAtual)
        ExitApp
    Else {
        MsgBox, 48, Senha incorreta, Senha incorreta. Tente novamente.
        GuiControl, 3:, Senha,
    }
Return

; ====================================================================
; 6. FECHAMENTO
; ====================================================================

1GuiClose:
    ExitApp
4GuiClose:
    Gui, 4: Destroy
    Gui, 1: Show
2GuiClose:
3GuiClose:
    ExitApp