//  Created by kamimura on 2018/07/21.
//  Copyright © 2018 kamimura. All rights reserved.
grammar SION;

SI_minus: '-';
SI_lsb: '[';
SI_rsb: ']';
SI_comma: ',';
SI_quote: '"';
SI_colon: ':';
SI_dot: '.';
SI_nil: 'nil';
SI_true: 'true';
SI_false: 'false';

si_self: si_literal
       | si_array
       | si_dict
       ;
si_array: SI_lsb SI_rsb
        | SI_lsb si_array_items SI_rsb
        ;    
si_array_items: si_self (SI_comma si_self)*;
si_dict: SI_lsb si_dict_pairs SI_rsb
       | SI_lsb SI_colon SI_rsb
       ;
si_dict_pairs: si_dict_pair (SI_comma si_dict_pair)*;
si_dict_pair: si_self SI_colon si_self;

si_literal: si_date
          | si_data
          | si_ints
          | si_doubles
          | si_string
          | si_bool
          | si_nil
          ;
          
si_ints: SI_minus? si_int;
si_doubles: SI_minus? SI_double;
si_bool: si_true
       | si_false
       ;
si_true: SI_true;
si_false: SI_false;

si_nil: SI_nil;

si_int: SI_bin
      | SI_oct
      | SI_decimal
      | SI_hex
      ;

si_data: SI_data;
SI_data: SI_data_pre SI_base64 SI_data_post;
fragment SI_data_pre: '.Data(';
fragment SI_base64: SI_quote SI_base64_item* SI_quote;
fragment SI_base64_item: [a-zA-Z0-9+/=];
fragment SI_data_post: ')';

si_date: '.Date(' (si_doubles | si_ints) ')';

SI_bin: SI_bin_pre SI_bin_digit SI_bin_digit_under*;
fragment SI_bin_pre: '0b';
fragment SI_bin_digit: [01];
fragment SI_bin_digit_under: SI_bin_digit
                           | SI_under;

SI_oct: SI_oct_pre SI_oct_digit SI_oct_digit_under*;
fragment SI_oct_pre: '0o';
fragment SI_oct_digit: [0-7] ;
fragment SI_oct_digit_under: SI_oct_digit
                           | SI_under
                           ;
SI_decimal: SI_decimal_digit SI_decimal_digit_under*;
fragment SI_decimal_digit: [0-9] ;
fragment SI_decimal_digit_under: SI_decimal_digit
                               | SI_under  ;

SI_hex : SI_hex_pre SI_hex_digit SI_hex_digit_under*;
fragment SI_hex_pre: '0x';
fragment SI_hex_digit : [0-9a-fA-F] ;
fragment SI_hex_digit_under: SI_hex_digit 
                           | SI_under
                           ;
SI_double: SI_decimal SI_decimal_frac? SI_decimal_exp?
         | SI_hex SI_hex_frac? SI_hex_exp
         ;
fragment SI_decimal_frac: SI_dot SI_decimal;
fragment SI_decimal_exp: ('e'|'E') SI_sign? SI_decimal;
fragment SI_hex_frac: SI_dot SI_hex_digit SI_hex_digit_under*;
fragment SI_hex_exp: ('p'|'P') SI_sign? SI_decimal;
fragment SI_sign: ('+'|'-');
fragment SI_under: '_';

si_string: SI_string_literal
         | SI_string_literal_multi
         ;
SI_string_literal: SI_quote SI_char* SI_quote;
fragment SI_char: SI_esc
                | ~["\r\n\\]
                ;
SI_string_literal_multi: '"""' SI_char_multi* '"""';
fragment SI_char_multi: SI_esc
                      | ~[\\]
                      ;
fragment SI_esc: '\\' [0\\tnr"'];
                    
SI_ws : [ \r\n\t\u0000\u000b\u000c]+ -> skip;
SI_comment : '//' .*? '\n' -> skip;