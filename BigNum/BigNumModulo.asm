;==========================================================
; ASM Testcase
; flype, 2015-10-03, v1.2
; BigNumModulo('11111222223333333333391152700', 97) = 22
;==========================================================
; https://github.com/flype44/M68K/blob/master/BigNum/BigNumModulo.asm
;==========================================================

;==========================================================
; Constants
;==========================================================

ASSERT_ZERO EQU $00D0000C

;==========================================================
; MAIN()
;==========================================================
    
    BRA     MAIN

MAIN:
    CLR.L   D0             ; Divider
    CLR.L   D5             ; Number of values processed
    CLR.L   D6             ; Error counter
    CLR.L   D7             ; Precalc
    LEA.L   VALUES,A0      ; BigNums
MAIN_LOOP:
    MOVE.B  (A0)+,D7       ; Get Precalc
    BEQ.B   MAIN_EXIT      ; exit if no more value
    MOVE.B  (A0)+,D0       ; Get Divider
    ADDQ.L  #1,D5          ; Increment Number of values processed
    JSR     BIGNUMMOD      ; BigNumModulo(number)
    SUB.L   D1,D7          ; D7 = precalc - calc
    BEQ     MAIN_ASSERT    ; Branch to Assert if D7 = 0
    ADDQ.L  #1,D6          ; Increment Error counter
MAIN_ASSERT:
    MOVE.L  D7,ASSERT_ZERO ; Assert D7 = 0
    ADDQ.L  #1,A0          ; Increment A0
    BRA     MAIN_LOOP      ; Continue
MAIN_EXIT:
    MOVE.L  D6,ASSERT_ZERO ; Assert D6 = 0
    STOP    #-1            ; Stop on Sim

;==========================================================
; Result = BIGNUMMOD(String)
; Input  : A0 = BigNumber
; Input  : D0 = Divider
; Output : D1 = Result
;==========================================================

BIGNUMMOD:
    CLR.L   D1             ; Result = 0
BIGNUMMOD_LOOP:
    TST.B   (A0)           ; While PeekB(*number)
    BEQ     BIGNUMMOD_EXIT ; End while
    MULU.W  #10,D1         ; Result * 10
    CLR.L   D2             ; D2 = 0
    MOVE.B  (A0)+,D2       ; Get digit
    ADD.L   D2,D1          ; Result + digit
    SUBI.L  #$30,D1        ; Result - $30
    DIVU.W  D0,D1          ; Result / Divider
    SWAP    D1             ; Result % Divider
    ANDI.L  #$0000FFFF,D1  ; Keep only LSB
    BRA     BIGNUMMOD_LOOP ; Continue
BIGNUMMOD_EXIT:
    RTS

;==========================================================
; Data Section
;==========================================================

VALUES:
    DC.B $05,$E6,'546285225171398980721814564173416132685222678129084857624985',0
    DC.B $52,$99,'622075952974971362005768182090922146241942106553487261141210',0
    DC.B $A4,$E9,'795716718007601794258842575635614490855774418575279614066026',0
    DC.B $06,$61,'288893567440853349103070745803538799152537684820370144353048',0
    DC.B $33,$43,'987346468300670229855535069637923759204208242831212869512718',0
    DC.B $17,$22,'840280274256358186251550501615737112934194050271557759629147',0
    DC.B $13,$16,'199236773996500125505493631831632451285810913872328634793889',0
    DC.B $CC,$D4,'523949320775462342096791037360247625371858091888216637792368',0
    DC.B $11,$32,'570160090869206186044196371034459303803323238563146875130017',0
    DC.B $02,$17,'605187706397618686547105182442895692924218668497052169329135',0
    DC.B $92,$A7,'749558434887980038901112342073540316644896363494131800493933',0
    DC.B $96,$F7,'616297649187560921313981576015116683901047904849176205202146',0
    DC.B $18,$23,'607077778397014130068068659165836111941333870890597902673019',0
    DC.B $35,$C2,'837038972136043834900369137529035566212587682898479712103671',0
    DC.B $61,$AF,'300393354094191780732720296866996507302037953788156319233897',0
    DC.B $5A,$C9,'134388450551763405469501840323668356344126638451784642397982',0
    DC.B $1A,$E1,'512395935297928145932971694857269202499846831819547341030676',0
    DC.B $61,$F1,'341476245002450543290093474686751010129939347332368320302497',0
    DC.B $1C,$9C,'023576465390737290183681561210582887092996775747261879647180',0
    DC.B $87,$DB,'889544232442766518966950450719324923742670130915343167389063',0
    DC.B $1E,$2B,'308965154658002700703414877598114766865149022491328229559251',0
    DC.B $16,$3F,'592347643241587591801498288520053639235744639646230685724057',0
    DC.B $6C,$F8,'660822774834835869290827895151401970681642400463666658958772',0
    DC.B $1F,$2F,'790642189084633372260116834994581076911482179026669446456188',0
    DC.B $07,$1D,'035672638322766035033927477050169490349619212627830876600335',0
    DC.B $1C,$23,'958016306245800153552075181658140042401923142047206293673528',0
    DC.B $6F,$B2,'140168244320882418135094788026765764249842384098224475822951',0
    DC.B $60,$CF,'812447218556724971233424690409121562819170014934695382559526',0
    DC.B $18,$49,'787875910536693920260598303113823390631292333033633750371040',0
    DC.B $99,$CB,'638225658858823218489686582936711702245550008023138866415370',0
    DC.B $1C,$53,'884697243773687486772736656127008395112039936317530564267639',0
    DC.B $6E,$74,'316540817597562719667276515862721522646446597265120356281958',0
    DC.B $04,$08,'449408517002677889843852390992054712071103741417771111915820',0
    DC.B $79,$A0,'833058762365861256304734304996295902594195004451620613268601',0
    DC.B $36,$3A,'886353147610550258977389092686698840464569446809510604072186',0
    DC.B $5C,$AB,'339693118044983472212901023023953321214597093719440217781652',0
    DC.B $08,$71,'632450324375150236453948842695055865088063428445751018472721',0
    DC.B $0B,$94,'605514855986922404239057084213527466776382057572976525954627',0
    DC.B $39,$CD,'015688645123162973132123514922622139086643773709538266490252',0
    DC.B $0B,$32,'849402990723366194046647424978435102384262791445615747357161',0
    DC.B $0A,$1C,'584648796839428647408519021324688664770205797496925219823338',0
    DC.B $3C,$48,'312457990105082815158322742833791796752202528697992716133140',0
    DC.B $04,$4D,'721815411107835605291246683410914971085407151513809603042577',0
    DC.B $B7,$FB,'852251018495778279600971060037856114868823711378664258210129',0
    DC.B $19,$27,'640757204372841643344250229760494385109947262008639777333781',0
    DC.B $39,$4C,'065608196871890106609100437269135180109616835672029175263049',0
    DC.B $1B,$99,'834454470940797482586157158396879953465984955276916595309310',0
    DC.B $20,$A4,'142668635849814294463181416813981592122529134210337602479528',0
    DC.B $41,$6F,'286094792511264758735776686716846517019296044192364311997296',0
    DC.B $72,$77,'207965455899599898335186130588295879208462414260577386260115',0
    DC.B $BA,$C2,'067463591280896936111497495881726785014132054192772332106514',0
    DC.B $23,$73,'581624815407233481121001707704709457442567347413816770026705',0
    DC.B $14,$20,'256402890547938592557853089675393247225276732754144349137556',0
    DC.B $04,$4D,'742608493180328852292248661758513484182779452711364997882374',0
    DC.B $04,$33,'227041353806426660539206897213399014047187688416567123680021',0
    DC.B $0C,$10,'094874907783998893327155657868103970426733730103200769917484',0
    DC.B $28,$61,'327097360147146945369950530810771777277951938272827796022283',0
    DC.B $19,$2C,'780775160686757247503681653618378334710686378211458354048049',0
    DC.B $60,$6D,'520802128713591855697714044665008579790754092479210026893218',0
    DC.B $C9,$D0,'571033279389925398805777660046696346612019488736817849208745',0
    DC.B $16,$1E,'715351515187048204462622781627663034812892786418017691949502',0
    DC.B $11,$34,'718692958775414108887888225843805622327403766302433705016709',0
    DC.B $18,$7A,'328280213380006189863448650410208232296302315810575721804238',0
    DC.B $04,$C4,'559630271127019684271970982588100192918049557958409748788156',0
    DC.B $0E,$CC,'912810981788511433206188656525174547310520623481446132303314',0
    DC.B $91,$9A,'237761989563303406399514975613460459520162785071199132497365',0
    DC.B $1A,$A1,'545658437527235564411309710717914685820499732769891792040871',0
    DC.B $06,$0A,'967730916101275188555196754722046570487362813449520781784266',0
    DC.B $35,$D9,'906208724014244752300304205592231197229455910122242475855149',0
    DC.B $37,$6B,'774749802814236671270949036450290944841837354517410094144163',0
    DC.B $0A,$C3,'574245171095466688992574539497201289231822116867687128496200',0
    DC.B $83,$C1,'793383071778339670282988295235822093244199564108038125824907',0
    DC.B $62,$C2,'451872085509409949536614909624255226255368318328385955933992',0
    DC.B $51,$9B,'170561722397110796177863294831247889957887757983547227281931',0
    DC.B $2A,$8F,'026654548503812476538148004345728434988204900378344501049907',0
    DC.B $48,$5C,'676347546637901279974905327134695527209339112390941824080768',0
    DC.B $C7,$CC,'065485936232104058696641766861573987608267150043964946599463',0
    DC.B $3B,$48,'620256481958043458374979833749757740307512735172979891539187',0
    DC.B $30,$45,'799028222875490772754405634314287119809509270464479338668196',0
    DC.B $03,$05,'359553089491400414722098907901296559572101597463087753615543',0
    DC.B $02,$15,'497356037064684655925073737372085693569152186807630588749368',0
    DC.B $46,$52,'242248834886263566805230101259146984355250423602948682779270',0
    DC.B $41,$9F,'481067785923999449578406878148580591088345340482466757528338',0
    DC.B $15,$25,'804415017874352846095439837413105804023362169069433560320927',0
    DC.B $24,$31,'662928102949654708052563280007058062226786339339705209241722',0
    DC.B $59,$C9,'433413543901910207617727953932072534957305862599720425396295',0
    DC.B $18,$3C,'558527652495618270430628743398617843987074981328801970843804',0
    DC.B $53,$6F,'119345488169432657589587037100813585511436993703698775613423',0
    DC.B $68,$8C,'166806132749441008841070804347404416380455562530054261733384',0
    DC.B $05,$16,'513667081060211276074490848403544771340128621052987103332803',0
    DC.B $AE,$EA,'070587748889379986564302362332189841848007737788521799558386',0
    DC.B $2D,$A3,'493152534920758340548392392556475565926730771084939749276521',0
    DC.B $58,$DC,'818292745970052882769472029684391052221212762821500547558408',0
    DC.B $14,$3A,'179211533558578043335304993420219919588774511647378570252806',0
    DC.B $08,$25,'124393434591416382527839037885927264697004859822372874039327',0
    DC.B $0C,$14,'210716948766951592743580573634671712147471682012921783170912',0
    DC.B $4E,$F7,'705765756159734642631489205177748834491729393965779376437574',0
    DC.B $8B,$EB,'073668565744065665760379756987026706098739316194520830747039',0
    DC.B $9F,$BC,'351940302463283949545814272790589775482711724877968899004379',0
    DC.B $F9,$FF,'936543582473856188707153010555604445340952982357846395447144',0
    DC.B 0

;==========================================================
; End of file
;==========================================================
    
    END
