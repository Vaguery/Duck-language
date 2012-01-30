require_relative '../lib/duck'
require_relative '../examples/conveniences'

# DuckInterpreter.new("x -8 -2 x -3 if x x * x x x 7 - x * x 7 7 * inc 3 -2 - * - dec -8 * +",{"x"=>Int.new(4)}).cartoon_trace
# 
# DuckInterpreter.new("x -263 / x * x -888 / inc x if -885 * 539 905 x x -13 dec + * x -262 + dec 944 - - 805 +",{"x"=>Int.new(4)}).cartoon_trace
# 
# DuckInterpreter.new("copy copy depth ≤ T neg be",{"x"=>Int.new(4)}).cartoon_trace
# 
# DuckInterpreter.new("-445 x x x 978 572 x * if 504 / - x * x x x dec -172 30 x - x x dec inc * if + -35 x 761 776 / * x x x * 207 x inc x * 37 -925 215 inc -682 +",{"x" => [Int.new(3),Int.new(4)]}).cartoon_trace
# 
# DuckInterpreter.new("x x * dec x ∨ x + * + depth +",{"x" => [10, 3, 6, 0, 5, 0, 5, 2, 2, 0, 4, 5, 0, 6, 1, 2, 3, 5, 5, 0].collect{|i| Int.new(i)}}).cartoon_trace

# DuckInterpreter.new("x x < 509 inc inc < x x * x ∨ depth ∧ 328 ∧ > > -980 - x x depth x + eql depth x x < eql ∨ * ∨ x > inc dec * * x > ∧ * eql / - inc - eql depth 320 depth -",{"x" => [10, 3, 6, 0, 5, 0, 5, 2, 2, 0, 4, 5, 0, 6, 1, 2, 3, 5, 5, 0].collect{|i| Int.new(i)}}).cartoon_trace


# bowling score performance space:
training_data = {[2, 0, 5, 4, 2, 0]=>13, [1, 4, 0, 6, 8, 0]=>19, [10, 7, 0, 3, 0, 0, 0, 0, 0]=>27, [9, 1, 7, 2, 1, 5, 10, 5, 5, 9]=>71, [5, 0, 7, 3, 4, 4, 0, 8, 6, 1, 0, 1]=>43, [4, 1, 10, 7, 3, 0, 3, 2, 6, 4, 2]=>52, [2, 6, 7, 1, 3, 1, 0, 7, 9, 0, 10, 0, 10]=>56, [10, 0, 4, 3, 6, 1, 6, 5, 5, 5, 4]=>58, [6, 2, 5, 3, 1, 4, 10, 5, 5, 5, 2]=>63, [6, 3, 0, 3, 5, 0, 9, 1, 3, 5, 1, 2, 1, 5]=>47, [9, 0, 3, 7, 2, 7, 6, 0, 3, 2, 3, 7, 2, 2]=>57, [9, 0, 4, 5, 9, 1, 2, 0, 10, 0, 5, 0, 10, 8]=>70, [3, 2, 8, 1, 9, 1, 6, 0, 4, 5, 7, 3, 10, 9, 1]=>85, [10, 3, 5, 7, 3, 10, 10, 2, 6, 1, 2]=>97, [5, 5, 2, 2, 8, 1, 4, 1, 9, 0, 6, 1, 5, 1, 1, 0]=>53, [1, 7, 5, 3, 3, 4, 9, 0, 10, 1, 3, 4, 1, 6, 0]=>61, [6, 2, 2, 6, 5, 4, 7, 2, 9, 0, 5, 0, 7, 0, 3, 4]=>62, [2, 5, 0, 6, 2, 4, 10, 6, 1, 3, 1, 2, 3, 10, 0, 4]=>66, [9, 1, 3, 3, 5, 5, 1, 3, 1, 6, 9, 0, 5, 3, 5, 4]=>67, [6, 0, 10, 8, 0, 4, 5, 5, 4, 2, 3, 1, 3, 10, 5, 1]=>75, [6, 2, 4, 3, 4, 5, 0, 4, 9, 1, 3, 7, 9, 0, 4, 5]=>78, [4, 2, 8, 2, 2, 8, 8, 2, 5, 1, 8, 1, 9, 0, 2, 6]=>83, [2, 5, 10, 3, 5, 9, 1, 2, 3, 10, 5, 0, 4, 6, 6]=>86, [4, 6, 9, 0, 8, 0, 7, 3, 4, 1, 9, 1, 4, 4, 9, 1, 2]=>89, [5, 5, 3, 0, 9, 1, 3, 5, 4, 5, 8, 0, 10, 3, 7, 6]=>90, [9, 0, 10, 5, 5, 3, 4, 8, 2, 6, 1, 8, 1, 5, 5, 3]=>94, [3, 2, 10, 10, 9, 1, 4, 4, 0, 6, 5, 2, 3, 5]=>97, [7, 0, 2, 6, 0, 6, 3, 0, 2, 4, 2, 0, 7, 0, 3, 6, 2, 1]=>51, [3, 4, 9, 0, 2, 5, 2, 3, 5, 5, 5, 0, 0, 3, 3, 5, 8, 1]=>68, [3, 4, 8, 0, 4, 5, 6, 4, 7, 1, 9, 0, 1, 3, 4, 6, 6, 1]=>85, [1, 2, 10, 8, 2, 2, 4, 4, 6, 10, 3, 0, 6, 3, 1, 0]=>87, [4, 5, 8, 1, 3, 7, 6, 4, 10, 2, 6, 5, 0, 9, 1, 3, 5]=>106, [10, 8, 1, 0, 7, 1, 7, 5, 5, 10, 2, 8, 3, 2, 6, 4, 7]=>118}

population = ["> x < ¬ pop inc T T neg -4 F 6 ( -2 x ) ungreedy be reverse dec * -4 < reverse -1 4 x -0 x F pop ≤ << greedy x x depth",
"ungreedy ungreedy empty x F x 4 T T x ≥ 9 x ≤ -3 ¬ / -4 + do be if x 6 x x if empty * depth 0 F T 5 x ungreedy F unshift ¬ ∧ copy x T pop -7 F -9 x ∨ do F -5 + be / >> 2 T 4 1 -4 x + 6 -10 F depth",
"reverse -1 ∧ empty swap x x greedy x F F ) quote / reverse x pop shatter x x >> 4 x F * copy ≤ x x x greedy greedy? do zap x neg x x depth ≤ 2 1 -5 + greedy? F ≤ -24 + ≤ greedy? ungreedy x -2 do x << copy reverse depth 1 do *",
"x ≥ do + shatter -99 x quote F ∧ * -9 x F F ) quote / reverse x pop shatter x x >> 6 x F * copy ≤ x x x know? greedy? do zap x neg x x depth ≤ 8 6 -8 + greedy? F ≤ -0 + ≤ greedy? ungreedy x -2 do x << copy reverse depth 1 do *",
"T inc + 9 empty -2 << T -3 F T ≤ ∨ - >> / 6 F << do -5 x ≥ -7 T ( ungreedy ( quote T x ¬ x -7 zap F x F F ( ¬ depth unshift pop T",
"T -7 F depth x zap F if x 4 + if x ≥ ∨ copy - << x ¬ if x shatter T be do -8 -7 T ( + x 4 greedy? x -5 T > 8 -7 x ≥ x 4 x 2 ∧ if 1 ) > 5 5 x swap zap x -7 F greedy? pop zap ) 0 quote T T < F x F quote zap ≥ < x -4 7 x shift x F pop ≤ / greedy x x depth",
"9 be do neg / know? T 8 ¬ know? be x depth ungreedy greedy? shift reverse dec dec x -5 swap -7 x -6 F ≥ F ≤ x x ( T x depth",
"-9 < do be x x 3 quote know? 4 ¬ T ∨ ungreedy greedy? zap x -8 << greedy? T pop < x ≥ x x ) ) ∨ dec 3 -2 swap x -7 reverse T F 2 T zap unshift do T x -8 F x ∨ ¬ depth F 5 depth 8 -3 -4 neg shift quote copy ( x quote * x depth",
"F ≤ -2 -0 * ungreedy F ≤ F x unshift / swap x if > 4 inc if -7 F - 6 F *",
"know? swap F ≥ x depth 2 copy reverse ) + * pop F pop F 8 0 -8 pop do F know? 6 x / x > 7 8 ungreedy 9 do *",
"know? 7 unshift x be pop -4 ungreedy / -1 eql -9 quote T -5 shatter T x x be dec dec greedy? >> << neg ∧ zap / x do 5 inc F -6 depth + 5 +",
"pop know? 6 9 F reverse T T < F x F quote zap ≥ < x -2 9 x shift F F pop ≤ / greedy x x depth",
"x ≥ do be x x 1 F F x x -6 x T >> << 5 ∧ F / ≤ do -2 -5 F -7 7 -2 F -3 F if x be 1 x ( x -70 neg ∧",
"-3 -7 dec F x zap greedy greedy eql ∧ 0 ( -4 x ) ungreedy be x dec 5 -8 if ∨ -8 x x 8 x F pop ≤ << greedy x if depth",
"T do x -7 x >> / 5 x -4 >> * x 2 x x depth",
"know? 2 unshift x be pop -2 ungreedy / -0 eql -5 quote T -5 shatter T x x be dec dec greedy? >> << neg ∧ zap / x do 7 inc F -8 depth + 3 +",
"be x x T inc ∨ x ≤ << 2 x if depth",
"x >> do 1 x x zap F F ) quote / T x pop shatter do x >> 2 x F * copy ≤ x x x know? greedy? do zap x neg x x depth ≤ 3 6 -6 + greedy? F ≤ -1 + ≤ greedy? ungreedy x x do x << copy reverse depth 1 do *",
"shatter x > be ∧ x T -1 -1 -51 8 x x 4 T shatter x neg T 1 greedy? ≤ 6 know? x << depth F pop swap",
"-4 be 1 unshift - quote x ∨ x reverse / x > copy reverse depth 3 do *",
"-7 pop x dec zap T x F do > / know? 4 depth << x F x depth ¬ -5 unshift greedy? -8 pop 7 3 T depth",
"x neg > x << depth x x inc 6 ∨ x * if greedy x 6 ∧ x / 3 do F if x be 1 x ( x -88 neg ∧",
"9 T T T F >> shift unshift < ≥ 5 * F 5 / pop -5 F x x know? ≥ know? T -10 empty 8 shatter << 5 + unshift unshift if T ¬ ¬ F F -1 -3 dec F F know? F < reverse shift swap T x -6 > -10 F 4 x shift > depth",
"∨ eql ungreedy swap shatter ∨ F -6 copy pop x F T F x inc shatter ( x 8 ( ≥ F < -4 T ) -3 if T x reverse know? * x 3 x x depth ¬ know? +",
"do x inc 2 -5 x -1 + F -1 greedy? depth unshift",
"-3 ) x F x zap T 6 * 6 dec T",
"x neg > x << depth x x inc 2 ∨ x * if greedy x 1 ∧ x / 4 do F if x be 5 x ( x -30 neg ∧",
"x shatter + + + +",
"F ≤ -9 -1 * ungreedy F ≤ F x unshift / swap x if > 1 inc if -0 F - 2 F *",
"x pop T greedy 8 * - greedy / x inc F know? x pop inc > T be be -5 T x pop T 9 do *",
"∨ x ¬ -7 x x / -4 T T F x x pop + T x pop + reverse know? >> 8 x shatter x neg empty - << -8 << 9",
"8 ( ( shatter 1 + 6 +",
"T x x 2 -54 6 x unshift F 2 4 x ( x neg F be 9 zap ( 0 9 F -4 T F ( -",
"x x pop greedy x x 9 quote F T x -3 x empty >> greedy? 4 ∧ -7 / pop do 9 5 F - depth + 4 +",
"shift + -7 -76 x 1 T copy -0 x ∨ x 8 x F if ¬ / * ∨ T 8 x + reverse -1 x 5 ( be -6 reverse do if -",
"9 2 + ∨ x -0 7 > > +",
"2 7 >> ≤ 0 >> swap x know? quote inc x empty 6 9 1 +",
"3 6 3 ≤ 9",
"copy F empty pop - x greedy - 9",
"depth swap greedy 4 -7 shatter ≥ x 9",
"unshift ≥ copy be x x 3 zap F be copy << x ≤ 9 ungreedy << 1 pop",
"quote x x greedy x dec x T swap -1 zap F quote * T << ≥ * 9 x -9 know? x know? F <",
"¬ x inc 8 x F F T ungreedy T x do * x x ) x -5 T know? x x x - zap x ( x 9 copy quote greedy?",
"≤ -3 know? + x do < x >> > + ( 1 6 T dec x T * 1 T neg T x -7 x T ∧ x -7 depth -3 x shift >> zap x x > F >> + 9 2 9 8 - < < -5 9 >> >>",
"x / eql inc be copy dec ≥ pop x quote F ≥ F inc 5 ) eql reverse 9 x pop >> + shift x shift x x * ≤ x zap copy greedy? F << greedy x 0 x 9",
"x ∨ 0 reverse dec ¬ - 7 inc ) be reverse x if copy dec + inc ∨ x shift ( 7 neg ¬ x -0 x 1 + shift unshift ∧ x 3 ≥ T x T x F 2 6 ¬ greedy? T x greedy x F - ∧ -3 x x 9 ungreedy",
"pop ( x T 8",
"7 x F eql 9 x 7 -5 empty F T x ( zap -3 3 T 4 8 if",
"¬ x inc 8 x F F T ungreedy F ∧ do * x x ) neg -3 T 8",
"- T T + 0 -8 / zap ≥ ∧ x 1 T > - 5 ungreedy 8 do greedy?",
"> x swap unshift ungreedy ≥ dec x dec x - zap -6 ( F F ≥ -",
"9 x ( 1 ungreedy F F copy ∨ x -7 know? F neg F -22 T -3 < x x x F 8 ¬",
"unshift T empty T ≤ * x do F x x copy 1 -1 ) x greedy ∧ 4 x -90 4 x ( shatter 7 -6 x F x quote x >> greedy know? pop dec T < if zap x >> T x shatter x ¬ < T 2 8",
"pop F 9 ( zap -1 -5 inc 6 greedy? -3 ungreedy < ∧ F x ) -9 if x ) x ) if F x -6 -5 5 shift x > if x copy T ≤ T x unshift / swap inc if > pop -10 reverse x greedy depth << ¬ -9 x 8 copy quote greedy?",
"shift shatter x F >> inc ∧ -3 x - swap ∧ -1 x / F ∧ x pop quote >> quote do F reverse copy x pop x do -2 T 8 x * T T if + << T -5 greedy? x * x greedy if x if -7 6 2 F ¬ T >> -6 >> if if if shift x -3 ¬ greedy? ¬ 5 F know? x empty << neg quote x << + greedy? ≤ -3 greedy -9 3 T 2 T ( 8 8 copy x ∧ 8",
"7",
"x 7",
"0 ( ( shatter 0 + 7 +",
"unshift ≥ copy be x x 1 zap F be copy << x ≤ 7 ungreedy << 6 pop",
"x / ≤ -1 -8 zap T F unshift be F F x reverse -4 T unshift -6 * F empty -8 pop x T * empty shatter know? T x inc x / pop -1 x -5 8 copy ≥ dec - shatter",
"8 F F x < T do >> x shift shatter x neg T F x -8 inc - F x pop pop x x do depth ) x T -1 ≥ ungreedy ∨ 3 < -6 copy -6 ungreedy dec T 2 / x ungreedy neg -6 x zap -4 pop T / x do 7 F unshift T F",
"swap copy 1 neg 2 shift empty 0 * neg ungreedy shatter T 0 x -8 inc -7 x ≥ swap F -4 T -2 F - 8 -9 ≥ x reverse ∧ F 2 ∨ ( x - x x inc < -6 T greedy 4 greedy >> -10 F copy x 5 depth ∧ dec eql x copy 7",
"≥ 3 x > unshift ∨ depth >> -1 F * -89 F x T 0 8 reverse T if x F -0 pop -47 x x x quote << ¬ -0 x 6 copy quote greedy?",
"-8 greedy ¬ know? T shatter greedy > / x -8 ∨ unshift reverse shift T unshift 9 -2 greedy? F T x inc ) F 1 zap - ∧ shatter reverse F x unshift / swap -8 if > 0 inc 6 0 +",
"F -8 -7 F x 1 eql x -7 quote 8 x << x x empty depth T do x 5 neg < swap + >> x reverse neg dec -9 << quote ∨ T quote ≥ * ( F 1 x x depth reverse x T - F T x F -5 x greedy? x know? zap reverse inc ( F greedy 7 x shatter 3 eql ∨ ∨ inc T - ) x x x 1 depth x T if ∨ + reverse x ∧ -3 neg unshift x >> + know? ∨ T x zap x > - ungreedy x -0 depth -5 know? 2 ¬ F -9 shatter pop 6",
"5 x F eql 7 x 7 -7 empty F T x ( zap -9 6 T 6 5 if",
"F T F swap pop x inc << pop copy quote F eql -8 -13 >> x shift 2 x > x 5 ∨ F",
"know? swap F ≥ x depth -3 copy reverse depth -2 inc > quote ∧ ∨ -4 depth x x inc 2 ∨ x * if greedy x 1 ∧ x / 4 do F if x be 5 x ( x -30 neg 4",
"> x dec << copy ungreedy quote 1 -5 if zap -9 - greedy? x x -7 ≥ 2 x ∨ eql >> ungreedy > inc T 7 x pop T + x 5 dec copy reverse ∧ >> ¬ -9 ¬ T ≤ x 4",
"T x ungreedy dec depth T 1 x 6 x 6 T F x x x x 8 ≤ T -2 -19 x ¬ 2 + 8 swap x << ≤ quote T greedy greedy T greedy x greedy? / if neg 4 / F greedy? zap unshift T quote T -6 x greedy x T 3 ) < shift 5 ≥ x * x greedy? pop ( T 8 neg ∧ empty 1 pop T 4 T",
"x x pop greedy x x 7 quote F T x -9 x empty >> greedy? 2 ∧ -8 / pop do 1 9 F - depth + 8 +",
"quote >> swap F do F ≥ << x x T -3 x greedy -4 2 if x neg F ) x T greedy * unshift -9 know? depth -10 T x -2 unshift greedy? + inc x x + T >>",
"x 2",
"<< < do be x x 2 quote know? 3 ¬ x x inc ∧",
"eql x do shatter T zap >> / 3 ( x T x eql )",
"6 -1 x F x x 8 5 -9 F x know? x ungreedy know? ¬",
"x x T 5 ( -5 0 shift T if T F eql T x ≤ know? ungreedy x 1 < x ¬ T x - x T shift /",
"x shift reverse shift x copy empty depth / x 0 >> F inc F unshift x 6 swap reverse -8 T reverse be -5 greedy x -2 pop x copy 7 -7 0 x greedy? depth unshift x shatter -3 < eql swap x x x x *",
"x x + * x (",
"depth pop do 4 1 3 1 shatter T 0 +",
"x x do shatter T x >> T / if ≤ eql / - copy x",
"reverse T -1 9 ∨ 8 reverse / F > 4 x T F 2 ∧ x",
"eql * ungreedy 8 -90 -3 T -5 -2 ) F pop 4 x x (",
"x pop x x - neg F inc F 4 empty be F pop x 1 x 3 F x -5 6 empty x do + -1 ¬ -9 -6 T 8 x shatter x",
"+ T empty x >> / T >> 6 x * greedy ) zap - > x x neg greedy? - 9 6 dec ( quote T x T -7 ( x pop ≥ neg x do",
"6 x ≥ zap 4 >> shatter * >> -7 pop shift ungreedy < 0 F F reverse -7 -2 x ungreedy -2 0 -9 inc if ≥ greedy? x T < dec pop swap ¬ inc -1 ¬ 2 x F ≤ << x F if 4 shift copy x F",
"dec greedy << -0 ≥ x x ≥ x T T < dec ∨ know? 8 -48 -3 shift F ¬ 1 x x -3 x greedy >> eql unshift -1 know? x >> 2 F greedy? >> -7 ∨ x neg neg x x x -6 unshift x shatter x copy",
"if if greedy T -4 1 x T reverse x F copy 4 x x swap -1 depth - x be pop + T 1 depth -6 swap x x F know? T 8 zap x inc F x x F 8 T pop ungreedy -2 do ≤ empty -8 swap ∨ ( T x reverse",
"F swap do >> -3",
"9 6 x ( -6 2 if",
"< reverse T if pop F eql 2 ungreedy -1 T ≤ -2 x T 3 4 + x F -04 copy ≤ x >> -6",
"( if greedy -0 - x - empty -5 x ∨ * x x * << ¬ ≤ inc >> -0 swap >> 0 T x F x swap 8 * + 8 T T ungreedy ungreedy eql 8 ≥ know? empty neg x x depth * + reverse -91 shift ∧ 4 >> -8 ¬ T 5 if depth 5 << * 3 - F x -4 x 6 F F neg unshift",
"7 ( ( shatter 9 + 9 greedy? 1 ∧ 5 / pop do ( 2 F - T + -91 +",
"x x greedy? ∧ / ≥ ∨ greedy? ¬ unshift x - x ( x -62 -5 x T shift x -5 x do x x T -8 T 0 x x - x F pop ≤ << F x if depth",
"T do -3 < -5 dec",
"-1 pop 2 F + 4 know?",
"unshift depth swap < pop ≥ 5",
">> << ) << greedy? F x F F T neg ¬ empty F 0 x if x x -4 / copy T - x -9 ungreedy + reverse -2 depth be F shift 4 (",
"depth x < -9 4 4 << ∧ ¬ << F x T F F greedy? / x x < -41 pop ) ≤ > -1 x -9 pop ungreedy 2 reverse ) 6 > -98 shatter pop 7 pop ( ∨ 6 ¬ x -6 inc eql pop T x x x 6 pop greedy F"]

def performance_over_IO_pairs(script,training_data)
  training_data.collect do |key, val|
    d = DuckInterpreter.new( 
      script,
      {"x" => key.each.collect{|i| Int.new(key[i].to_i)} } ).run

    where = d.topmost_respondent("inc")
    where.nil? ? 1000000 : (val-d.stack[where].value).abs
  end
end

def performance_space(population,training_data)
  population.collect do |answer|
    performance_over_IO_pairs(answer,training_data)
  end
end

def show_space(performance_space)
  performance_space.each {|l| puts l.inject("") {|s,n| s+"#{n},"}.chop}
end



# puts performance_space(population,training_data).inspect

DuckInterpreter.new("eql empty x ( -3.777 - < << give 4.214 known ≥ / T eql < x -6.333 []= copy be 5 << if zap ∧ 2.496 pop x know? -3 dec T F x depth F empty F greedy unshift x -7 ∧ greedy? -8 -6 x greedy copy", {"x" => Int.new(12)}).cartoon_trace

# 1000.times do |i|
#   begin
#     puts i
#     @some_script = random_script(200)
#     DuckInterpreter.new(@some_script, {"x" => [2, 0, 5, 4, 2, 0]}).run
#   rescue
#     puts "FAILURE in #{@some_script.inspect}"
#   end
# end
