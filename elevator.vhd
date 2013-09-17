----------------------------------------------------------------------------------
-- Company: WebLab-Deusto
-- Engineer: Gustavo Martin Vela
-- 
-- Create Date:    16:56:08 03/22/2013 
-- Design Name: 
-- Module Name:    elevator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity elevator is
    Port (
	 

inicio: in std_logic;

clk: in std_logic;
slow2sw: in std_logic;
slow0sw: in std_logic;
slow1topsw: in std_logic;
slow1bottomsw: in std_logic;
floor1sw: in std_logic;
floor2sw: in std_logic;
floor0sw: in std_logic;
--doors
opened0: in std_logic;
closed0: in std_logic;
opened1: in std_logic;
closed1: in std_logic;
opened2: in std_logic;
closed2: in std_logic;

--call buttoms
panel0: in std_logic;
panel1: in std_logic;
panel2: in std_logic;
call0: in std_logic;
call1up: in std_logic;
call1down: in std_logic;
call2: in std_logic;



--Outputs
luz: out std_logic;
luz1: out std_logic;
luz2: out std_logic;
up: out std_logic;
down: out std_logic;
slow: out std_logic;
--
---- top indicators
ind0: out std_logic;
ind1: out std_logic;
ind2: out std_logic;

ind_up: out std_logic;
ind_down: out std_logic;








---doors
close0: out std_logic;
open0: out std_logic;
close1: out std_logic;
open1: out std_logic;
close2: out std_logic;
open2: out std_logic;
panel_led0: out std_logic;
panel_led1: out std_logic;
panel_led2: out std_logic;
panel_led0_aux: out std_logic;
panel_led1_aux: out std_logic;
panel_led2_aux: out std_logic;
led0: out std_logic;
led1up: out std_logic;
led1down: out std_logic;
led2: out std_logic;
motors: out std_logic;
sensors: out std_logic




           );
end elevator;


architecture behavioral of elevator is


signal estado:integer range 0 to 9;

signal door0:integer  range 0 to 2;
signal door1:integer  range 0 to 2;
signal door2:integer  range 0 to 2;
signal cont: integer range 0 to 99999999;




--signal of the calls
signal called0: std_logic;
signal called1: std_logic;
signal called1up: std_logic;
signal called1down: std_logic;
signal called2: std_logic;
signal goingup: std_logic;
signal goingdown: std_logic;

signal cont_filtroa: std_logic_vector (3 downto 0);
signal botonpanel0_filtrado: std_logic;
signal estadofiltroa: std_logic_vector (1 downto 0);

signal cont_filtrob: std_logic_vector (3 downto 0);
signal botonpanel1_filtrado: std_logic;
signal estadofiltrob: std_logic_vector (1 downto 0);

signal cont_filtroc: std_logic_vector (3 downto 0);
signal botonpanel2_filtrado: std_logic;
signal estadofiltroc: std_logic_vector (1 downto 0);


signal cont_filtro0: std_logic_vector (3 downto 0);
signal floor0: std_logic;
signal estadofiltro0: std_logic_vector (1 downto 0);

signal cont_filtro1: std_logic_vector (3 downto 0);
signal floor1: std_logic;
signal estadofiltro1: std_logic_vector (1 downto 0);

signal cont_filtro2: std_logic_vector (3 downto 0);
signal floor2: std_logic;
signal estadofiltro2: std_logic_vector (1 downto 0);

signal cont_filtros0: std_logic_vector (3 downto 0);
signal slow0: std_logic;
signal estadofiltros0: std_logic_vector (1 downto 0);

signal cont_filtros1top: std_logic_vector (3 downto 0);
signal slow1top: std_logic;
signal estadofiltros1top: std_logic_vector (1 downto 0);

signal cont_filtros1bottom: std_logic_vector (3 downto 0);
signal slow1bottom: std_logic;
signal estadofiltros1bottom: std_logic_vector (1 downto 0);

signal cont_filtros2: std_logic_vector (3 downto 0);
signal slow2: std_logic;
signal estadofiltros2: std_logic_vector (1 downto 0);
begin
motors<='1';
sensors<='1';
----filter switches
---------------------filtro floor0


process(inicio, clk,floor0sw) 
begin
if inicio='1' then 
   estadofiltro0<="00";
   cont_filtro0<="0000";
elsif clk='1' and clk'event then
   case estadofiltro0 is
   when "00" => -- INICIO
        cont_filtro0<="0000";
        if floor0sw='1' then
           estadofiltro0<="00";
        else
           estadofiltro0<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtro0<=cont_filtro0+1;
        if floor0sw='1' then
           estadofiltro0<="00";
        else
           if cont_filtro0<"1010" then
              estadofiltro0<="01";
           else
              estadofiltro0<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtro0<=cont_filtro0;
        if floor0sw='1' then
           estadofiltro0<="11";
        else
           estadofiltro0<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtro0<=cont_filtro0;
        estadofiltro0<="00";
   when others => estadofiltro0<="00";
   end case;
end if;
end process;
 

process(estadofiltro0)
begin
case estadofiltro0 is
when "00" => floor0<='1';
when "01" => floor0<='1';
when "10" => floor0<='1';
when "11" => floor0<='0';
when others => floor0<='1';
end case;
end process;

---------------------filtro floor1


process(inicio, clk,floor1sw) 
begin
if inicio='1' then 
   estadofiltro1<="00";
   cont_filtro1<="0000";
elsif clk='1' and clk'event then
   case estadofiltro1 is
   when "00" => -- INICIO
        cont_filtro1<="0000";
        if floor1sw='1' then
           estadofiltro1<="00";
        else
           estadofiltro1<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtro1<=cont_filtro1+1;
        if floor1sw='1' then
           estadofiltro1<="00";
        else
           if cont_filtro1<"1010" then
              estadofiltro1<="01";
           else
              estadofiltro1<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtro1<=cont_filtro1;
        if floor1sw='1' then
           estadofiltro1<="11";
        else
           estadofiltro1<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtro1<=cont_filtro1;
        estadofiltro1<="00";
   when others => estadofiltro1<="00";
   end case;
end if;
end process;
 

process(estadofiltro1)
begin
case estadofiltro1 is
when "00" => floor1<='1';
when "01" => floor1<='1';
when "10" => floor1<='1';
when "11" => floor1<='0';
when others => floor1<='1';
end case;
end process;

---------------------filtro floor2


process(inicio, clk,floor2sw) 
begin
if inicio='1' then 
   estadofiltro2<="00";
   cont_filtro2<="0000";
elsif clk='1' and clk'event then
   case estadofiltro2 is
   when "00" => -- INICIO
        cont_filtro2<="0000";
        if floor2sw='1' then
           estadofiltro2<="00";
        else
           estadofiltro2<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtro2<=cont_filtro2+1;
        if floor2sw='1' then
           estadofiltro2<="00";
        else
           if cont_filtro2<"1010" then
              estadofiltro2<="01";
           else
              estadofiltro2<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtro2<=cont_filtro2;
        if floor2sw='1' then
           estadofiltro2<="11";
        else
           estadofiltro2<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtro2<=cont_filtro2;
        estadofiltro2<="00";
   when others => estadofiltro2<="00";
   end case;
end if;
end process;
 

process(estadofiltro2)
begin
case estadofiltro2 is
when "00" => floor2<='1';
when "01" => floor2<='1';
when "10" => floor2<='1';
when "11" => floor2<='0';
when others => floor2<='1';
end case;
end process;


---------------------filtro slow0


process(inicio, clk,slow0sw) 
begin
if inicio='1' then 
   estadofiltros0<="00";
   cont_filtros0<="0000";
elsif clk='1' and clk'event then
   case estadofiltros0 is
   when "00" => -- INICIO
        cont_filtros0<="0000";
        if slow0sw='1' then
           estadofiltros0<="00";
        else
           estadofiltros0<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtros0<=cont_filtros0+1;
        if slow0sw='1' then
           estadofiltros0<="00";
        else
           if cont_filtros0<"1010" then
              estadofiltros0<="01";
           else
              estadofiltros0<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtros0<=cont_filtros0;
        if slow0sw='1' then
           estadofiltros0<="11";
        else
           estadofiltros0<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtros0<=cont_filtros0;
        estadofiltros0<="00";
   when others => estadofiltros0<="00";
   end case;
end if;
end process;
 

process(estadofiltros0)
begin
case estadofiltros0 is
when "00" => slow0<='1';
when "01" => slow0<='1';
when "10" => slow0<='1';
when "11" => slow0<='0';
when others => slow0<='1';
end case;
end process;

---------------------filtro slow2


process(inicio, clk,slow2sw) 
begin
if inicio='1' then 
   estadofiltros2<="00";
   cont_filtros2<="0000";
elsif clk='1' and clk'event then
   case estadofiltros2 is
   when "00" => -- INICIO
        cont_filtros2<="0000";
        if slow2sw='1' then
           estadofiltros2<="00";
        else
           estadofiltros2<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtros2<=cont_filtros2+1;
        if slow2sw='1' then
           estadofiltros2<="00";
        else
           if cont_filtros2<"1010" then
              estadofiltros2<="01";
           else
              estadofiltros2<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtros2<=cont_filtros2;
        if slow2sw='1' then
           estadofiltros2<="11";
        else
           estadofiltros2<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtros2<=cont_filtros2;
        estadofiltros2<="00";
   when others => estadofiltros2<="00";
   end case;
end if;
end process;
 

process(estadofiltros2)
begin
case estadofiltros2 is
when "00" => slow2<='1';
when "01" => slow2<='1';
when "10" => slow2<='1';
when "11" => slow2<='0';
when others => slow2<='1';
end case;
end process;

---------------------filtro slow1top


process(inicio, clk,slow2sw) 
begin
if inicio='1' then 
   estadofiltros1top<="00";
   cont_filtros1top<="0000";
elsif clk='1' and clk'event then
   case estadofiltros1top is
   when "00" => -- INICIO
        cont_filtros1top<="0000";
        if slow1topsw='1' then
           estadofiltros1top<="00";
        else
           estadofiltros1top<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtros1top<=cont_filtros1top+1;
        if slow1topsw='1' then
           estadofiltros1top<="00";
        else
           if cont_filtros1top<"1010" then
              estadofiltros1top<="01";
           else
              estadofiltros1top<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtros1top<=cont_filtros1top;
        if slow1topsw='1' then
           estadofiltros1top<="11";
        else
           estadofiltros1top<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtros1top<=cont_filtros1top;
        estadofiltros1top<="00";
   when others => estadofiltros1top<="00";
   end case;
end if;
end process;
 

process(estadofiltros1top)
begin
case estadofiltros1top is
when "00" => slow1top<='1';
when "01" => slow1top<='1';
when "10" => slow1top<='1';
when "11" => slow1top<='0';
when others => slow1top<='1';
end case;
end process;

---------------------filtro slow1bottom


process(inicio, clk,slow1bottomsw) 
begin
if inicio='1' then 
   estadofiltros1bottom<="00";
   cont_filtros1bottom<="0000";
elsif clk='1' and clk'event then
   case estadofiltros1bottom is
   when "00" => -- INICIO
        cont_filtros1bottom<="0000";
        if slow1bottomsw='1' then
           estadofiltros1bottom<="00";
        else
           estadofiltros1bottom<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtros1bottom<=cont_filtros1bottom+1;
        if slow1bottomsw='1' then
           estadofiltros1bottom<="00";
        else
           if cont_filtros1bottom<"1010" then
              estadofiltros1bottom<="01";
           else
              estadofiltros1bottom<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtros1bottom<=cont_filtros1bottom;
        if slow1bottomsw='1' then
           estadofiltros1bottom<="11";
        else
           estadofiltros1bottom<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtros1bottom<=cont_filtros1bottom;
        estadofiltros1bottom<="00";
   when others => estadofiltros1bottom<="00";
   end case;
end if;
end process;
 

process(estadofiltros1bottom)
begin
case estadofiltros1bottom is
when "00" => slow1bottom<='1';
when "01" => slow1bottom<='1';
when "10" => slow1bottom<='1';
when "11" => slow1bottom<='0';
when others => slow1bottom<='1';
end case;
end process;




---------------------filtro panel0


process(inicio, clk,panel0) --filtrado de A
begin
if inicio='1' then 
   estadofiltroa<="00";
   cont_filtroa<="0000";
elsif clk='1' and clk'event then
   case estadofiltroa is
   when "00" => -- INICIO
        cont_filtroa<="0000";
        if panel0='1' then
           estadofiltroa<="00";
        else
           estadofiltroa<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtroa<=cont_filtroa+1;
        if panel0='1' then
           estadofiltroa<="00";
        else
           if cont_filtroa<"1010" then
              estadofiltroa<="01";
           else
              estadofiltroa<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtroa<=cont_filtroa;
        if panel0='1' then
           estadofiltroa<="11";
        else
           estadofiltroa<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtroa<=cont_filtroa;
        estadofiltroa<="00";
   when others => estadofiltroa<="00";
   end case;
end if;
end process;
 

process(estadofiltroa)
begin
case estadofiltroa is
when "00" => botonpanel0_filtrado<='0';
when "01" => botonpanel0_filtrado<='0';
when "10" => botonpanel0_filtrado<='0';
when "11" => botonpanel0_filtrado<='1';
when others => botonpanel0_filtrado<='0';
end case;
end process;


------------------filtro panel1
process(inicio, clk,panel1) --filtrado de A
begin
if inicio='1' then 
   estadofiltrob<="00";
   cont_filtrob<="0000";
elsif clk='1' and clk'event then
   case estadofiltrob is
   when "00" => -- INICIO
        cont_filtrob<="0000";
        if panel1='0' then
           estadofiltrob<="00";
        else
           estadofiltrob<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtrob<=cont_filtrob+1;
        if panel1='0' then
           estadofiltrob<="00";
        else
           if cont_filtrob<"1010" then
              estadofiltrob<="01";
           else
              estadofiltrob<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtrob<=cont_filtroa;
        if panel1='0' then
           estadofiltrob<="11";
        else
           estadofiltrob<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtrob<=cont_filtroa;
        estadofiltrob<="00";
   when others => estadofiltrob<="00";
   end case;
end if;
end process;
 

process(estadofiltrob)
begin
case estadofiltrob is
when "00" => botonpanel1_filtrado<='0';
when "01" => botonpanel1_filtrado<='0';
when "10" => botonpanel1_filtrado<='0';
when "11" => botonpanel1_filtrado<='1';
when others => botonpanel1_filtrado<='0';
end case;
end process;
--------panel2 filter

process(inicio, clk,panel2) --filtrado de A
begin
if inicio='1' then 
   estadofiltroc<="00";
   cont_filtroc<="0000";
elsif clk='1' and clk'event then
   case estadofiltroc is
   when "00" => -- INICIO
        cont_filtroc<="0000";
        if panel2='0' then
           estadofiltroc<="00";
        else
           estadofiltroc<="01";
        end if;
   when "01" => -- PULSADO y filtrando
        cont_filtroc<=cont_filtroc+1;
        if panel2='0' then
           estadofiltroc<="00";
        else
           if cont_filtroc<"1010" then
              estadofiltroc<="01";
           else
              estadofiltroc<="10";
           end if;
        end if;
   when "10" => -- PULSADO y filtrado
        cont_filtroc<=cont_filtroc;
        if panel2='0' then
           estadofiltroc<="11";
        else
           estadofiltroc<="10";
        end if;
   when "11" => -- SOLTADO
        cont_filtroc<=cont_filtroc;
        estadofiltroc<="00";
   when others => estadofiltroc<="00";
   end case;
end if;
end process;
 

process(estadofiltroc)
begin
case estadofiltroc is
when "00" => botonpanel2_filtrado<='0';
when "01" => botonpanel2_filtrado<='0';
when "10" => botonpanel2_filtrado<='0';
when "11" => botonpanel2_filtrado<='1';
when others => botonpanel2_filtrado<='0';
end case;
end process;
-------------------
process(inicio,clk,call0)
begin
if inicio='1' then
	called0<='0';
	panel_led0<='0';
	panel_led0_aux<='0';
	
elsif clk='1' and clk'event then

if botonpanel0_filtrado='1'  then
	called0<='1';
	panel_led0<='1';
	panel_led0_aux<='1';
elsif call0='0' then
	called0<='1';
	led0<='1';
end if;
if estado=1 then
   called0<='0';
	panel_led0<='0';
	panel_led0_aux<='0';
	led0<='0';	
end if;
end if;
end process;


process(inicio,clk)
begin
if inicio='1' then
	called1<='0';
	panel_led1<='0';
	panel_led1_aux<='0';
elsif clk='1' and clk'event then

if botonpanel1_filtrado='1'  then
	called1<='1';
	panel_led1<='1';
	panel_led1_aux<='1';
elsif estado=6 then 
   called1<='0';
	panel_led1<='0';
	panel_led1_aux<='0';	
end if;
end if;
end process;


process(inicio,clk,botonpanel2_filtrado,call2)
begin
if inicio='1' then
	called2<='0';
	led2<='0';
elsif clk='1' and clk'event then

if botonpanel2_filtrado='1' then
	called2<='1';
	panel_led2<='1';
	panel_led2_aux<='1';
elsif call2='0' then
	called2<='1';
	led2<='1';
elsif estado=8 then
   called2<='0';
	panel_led2<='0';
	panel_led2_aux<='0';	
	led2<='0';
end if;
end if;
end process;

process(inicio,clk,call1up)
begin
if inicio='1' then
	called1up<='0';
	led1up<='0';
elsif clk='1' and clk'event then

if call1up='0' then
	called1up<='1';
	led1up<='1';
elsif estado=6 then
   called1up<='0';
	led1up<='0';	
end if;
end if;
end process;

process(inicio,clk,call1down)
begin
if inicio='1' then
	called1down<='0';
	led1down<='0';
elsif clk='1' and clk'event then

if call1down='0' then
	called1down<='1';
	led1down<='1';
elsif estado=6 then
   called1down<='0';
	led1down<='0';	
end if;
end if;
end process;

luz1<=slow1bottom;
ind_up<=goingup;
ind_down<=goingdown;
process(inicio,floor0,floor0sw,clk)
begin
	if inicio='1' then
	door0<=0;
	slow<='0';
	estado<=0;
	open0<='0';
	close0<='0';
	ind0<='0';
	ind1<='0';
	ind2<='0';
	cont<=0;
		if floor0sw='1' then
			down<='1';
			up<='0';
		elsif floor0sw='0' then
			down<='0';
			up<='0';
		end if;
	elsif clk='1' and clk'event then
			case estado is
				when 0 =>---in ground floor
					door0<=0;
					door1<=0;
					door2<=0;
				luz<='0';
				
					up<='0';
					down<='0';
					slow<='0';
					goingup<='0';
					goingdown<='0';
					ind0<='1';
					ind1<='0';
					ind2<='0';
					if closed0='1' then
						if called0='1' then
							estado<=1;
						elsif called2='1' or called1up='1' or called1down='1' or called1='1' then
							estado<=2;
						end if;
					
					end if;
				when 1 => --open 0
				
					case door0 is
						when 0 => --open
					
							open0<='1';
							close0<='0';
							cont<=0;
							if opened0='1' then
								door0<=1;
								
							end if;
						when 1 =>--wait
						
							open0<='1';
							close0<='0';
							cont<=cont+1;
							if cont=49999999 then
								door0<=2;
								cont<=0;
							end if;
						when 2 =>--cerrar
							open0<='0';
							close0<='1';
						
							cont<=cont+1;
							if cont=149 then
								if closed0='1' then
								open0<='0';
								close0<='0';
								estado<=0;
								end if;
							end if;
							
							
					end case;
				when 2 => --  up slowly
					up<='1';
					down<='0';
					slow<='1';
					goingup<='1';
					goingdown<='0';
					if slow0='0' or slow1top='0' then
						estado<=3;
					elsif floor1='0' then
						estado<=4;
					elsif floor2='0' then
						estado<=5;
					end if;
				when 3 =>--up fast
					up<='1';
					down<='0';
					slow<='0';
					goingup<='1';
					goingdown<='0';
					if slow1bottom='0' or floor1='0' then
						if called1up='1' or called1='1' then
							estado<=2;
						elsif called1down='1' and called2='0' then
							estado<=2;
						end if;
					elsif slow2='0' then
						estado<=2;
					end if;
				when 4 => --in floor 1

					up<='0';
					down<='0';
					slow<='0';
					ind0<='0';
					ind1<='1';
					ind2<='0';
					door1<=0;
					if closed1='1' then
						if called1='1' or called1up='1' or called1down='1' then
							estado<=6;
						elsif goingup='1' and called2='1' then
							estado<=2;
						elsif called0='1' then
							estado<=7;
						elsif called2='1' then
							estado<=2;
						end if;
					end if;
				when 5 => --In floor 2
				luz2<='0';
					up<='0';
					down<='0';
					slow<='0';
					ind0<='0';
					ind1<='0';
					ind2<='1';
					goingup<='0';
					goingdown<='0';
					door2<=0;
					if closed2='1' then
						if called2='1' then
							estado<=8;
						elsif called1down='1' or called1='1' or called0='1' or called1up='1' then
							estado<=7;
						end if;
					
					end if;
				when 6 => --Abrir 1
					case door1 is
						when 0 => --open
						
							open1<='1';
							close1<='0';
							cont<=0;
							if opened1='1' then
								door1<=1;
								
							end if;
						when 1 =>--wait
						
							open1<='1';
							close1<='0';
							cont<=cont+1;
							if cont=49999999 then
								door1<=2;
								cont<=0;
							end if;
						when 2 =>--cerrar
							open1<='0';
							close1<='1';
						
							cont<=cont+1;
							if cont=9999999 then
								if closed1='1' then
								open1<='0';
								close1<='0';
								estado<=4;
								end if;
							end if;
							
							
					end case;
				when 7 => --down slowly
					up<='0';
					down<='1';
					slow<='1';
					goingup<='0';
					goingdown<='1';
					if slow2='0' or slow1bottom='0' then
						estado<=9;
					elsif floor1='0' then
						estado<=4;
					elsif floor0='0' then
						estado<=0;
					end if;
				when 8 => --open 2
					case door2 is
						when 0 => --open
						
							open2<='1';
							close2<='0';
							cont<=0;
							if opened2='1' then
								door2<=1;
								
							end if;
						when 1 =>--wait
						luz2<='0';
							open2<='1';
							close2<='0';
							cont<=cont+1;
							if cont=49999999 then
								door2<=2;
								cont<=0;
							end if;
						when 2 =>--cerrar
							open2<='0';
							close2<='1';
						 luz2<='1';
							cont<=cont+1;
							if cont=9999999 then
								if closed2='1' then
								luz2<='0';
								open2<='0';
								close2<='0';
								estado<=5;
								else cont<=0;
								end if;
							end if;
							
							
					end case;
				when 9 => --down fast
					up<='0';
					down<='1';
					slow<='0';
					goingup<='0';
					goingdown<='1';
					if slow0='0' then
						estado<=7;
					elsif slow1top='0' then
						if called1='1' or called1down='1' then
							estado<=7;
						elsif called0='0' and called1up='1' then
							estado<=7;
						end if;
					end if;
				
				
				when others => estado<=0;
					
					
					
			end case;
		end if;
end process;

 end behavioral;
