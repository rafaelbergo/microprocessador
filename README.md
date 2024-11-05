## Projeto de um microprocessador utilizando VHDL
Instruções OBRIGATÓRIAS a serem usadas na sua validação: 

{'Acumulador ou não': 'ULA com acumulador',

 'Largura da ROM / instrução em bits': [17],
 
 'Número de registradores no banco': [9],
 
 'ADD ops': 'ADD com dois operandos apenas',
 
 'Carga de constantes': 'Carrega diretamente com LD sem somar',
 
 'SUB ops': 'Subtração com dois operandos apenas',
 
 'ADD ctes': 'ADD apenas entre registradores, nunca com constantes',
 
 'SUB ctes': 'Há instrução que subtrai uma constante',
 
 'Subtração': 'Subtração com SUB sem borrow',
 
 'Comparações': 'Comparação apenas com CMPR',
 
 'Saltos condicionais': ['BLE', 'BLO'],
 
 'Saltos': 'Incondicional é absoluto e condicional é relativo',
 
 'Validação -- final do loop': 'JB direto no bit b5 ou bn',
 
 'Validação -- complicações': 'Colocar no bus debug um divisor de 1171'}
