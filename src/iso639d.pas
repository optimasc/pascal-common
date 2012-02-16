{ File Generated on 2011-11-25 automatically }
{ and encoded in the ISO-8859-1 character set}
unit iso639d;

interface

const
  MAX_ENTRIES =485;
type
  TLangInfo = record
    code: string[2];
    biblio_code: string[3];
    name_fr: pchar;
    name_en: pchar
  end;


{$ifndef tp}
const
  LangInfo: array[1..MAX_ENTRIES] of TLangInfo = (
  (
   code: 'aa';
   biblio_code: 'aar';
   name_fr: 'afar';
   name_en: 'Afar';
  ),
  (
   code: 'ab';
   biblio_code: 'abk';
   name_fr: 'abkhaze';
   name_en: 'Abkhazian';
  ),
  (
   code: '';
   biblio_code: 'ace';
   name_fr: 'aceh';
   name_en: 'Achinese';
  ),
  (
   code: '';
   biblio_code: 'ach';
   name_fr: 'acoli';
   name_en: 'Acoli';
  ),
  (
   code: '';
   biblio_code: 'ada';
   name_fr: 'adangme';
   name_en: 'Adangme';
  ),
  (
   code: '';
   biblio_code: 'ady';
   name_fr: 'adygh'#233'';
   name_en: 'Adyghe; Adygei';
  ),
  (
   code: '';
   biblio_code: 'afa';
   name_fr: 'afro-asiatiques, langues';
   name_en: 'Afro-Asiatic languages';
  ),
  (
   code: '';
   biblio_code: 'afh';
   name_fr: 'afrihili';
   name_en: 'Afrihili';
  ),
  (
   code: 'af';
   biblio_code: 'afr';
   name_fr: 'afrikaans';
   name_en: 'Afrikaans';
  ),
  (
   code: '';
   biblio_code: 'ain';
   name_fr: 'a'#239'nou';
   name_en: 'Ainu';
  ),
  (
   code: 'ak';
   biblio_code: 'aka';
   name_fr: 'akan';
   name_en: 'Akan';
  ),
  (
   code: '';
   biblio_code: 'akk';
   name_fr: 'akkadien';
   name_en: 'Akkadian';
  ),
  (
   code: 'sq';
   biblio_code: 'alb';
   name_fr: 'albanais';
   name_en: 'Albanian';
  ),
  (
   code: '';
   biblio_code: 'ale';
   name_fr: 'al'#233'oute';
   name_en: 'Aleut';
  ),
  (
   code: '';
   biblio_code: 'alg';
   name_fr: 'algonquines, langues';
   name_en: 'Algonquian languages';
  ),
  (
   code: '';
   biblio_code: 'alt';
   name_fr: 'altai du Sud';
   name_en: 'Southern Altai';
  ),
  (
   code: 'am';
   biblio_code: 'amh';
   name_fr: 'amharique';
   name_en: 'Amharic';
  ),
  (
   code: '';
   biblio_code: 'ang';
   name_fr: 'anglo-saxon (ca.450-1100)';
   name_en: 'English, Old (ca.450-1100)';
  ),
  (
   code: '';
   biblio_code: 'anp';
   name_fr: 'angika';
   name_en: 'Angika';
  ),
  (
   code: '';
   biblio_code: 'apa';
   name_fr: 'apaches, langues';
   name_en: 'Apache languages';
  ),
  (
   code: 'ar';
   biblio_code: 'ara';
   name_fr: 'arabe';
   name_en: 'Arabic';
  ),
  (
   code: '';
   biblio_code: 'arc';
   name_fr: 'aram'#233'en d''''empire (700-300 BCE)';
   name_en: 'Official Aramaic (700-300 BCE); Imperial Aramaic (700-300 BCE)';
  ),
  (
   code: 'an';
   biblio_code: 'arg';
   name_fr: 'aragonais';
   name_en: 'Aragonese';
  ),
  (
   code: 'hy';
   biblio_code: 'arm';
   name_fr: 'arm'#233'nien';
   name_en: 'Armenian';
  ),
  (
   code: '';
   biblio_code: 'arn';
   name_fr: 'mapudungun; mapuche; mapuce';
   name_en: 'Mapudungun; Mapuche';
  ),
  (
   code: '';
   biblio_code: 'arp';
   name_fr: 'arapaho';
   name_en: 'Arapaho';
  ),
  (
   code: '';
   biblio_code: 'art';
   name_fr: 'artificielles, langues';
   name_en: 'Artificial languages';
  ),
  (
   code: '';
   biblio_code: 'arw';
   name_fr: 'arawak';
   name_en: 'Arawak';
  ),
  (
   code: 'as';
   biblio_code: 'asm';
   name_fr: 'assamais';
   name_en: 'Assamese';
  ),
  (
   code: '';
   biblio_code: 'ast';
   name_fr: 'asturien; bable; l'#233'onais; asturol'#233'onais';
   name_en: 'Asturian; Bable; Leonese; Asturleonese';
  ),
  (
   code: '';
   biblio_code: 'ath';
   name_fr: 'athapascanes, langues';
   name_en: 'Athapascan languages';
  ),
  (
   code: '';
   biblio_code: 'aus';
   name_fr: 'australiennes, langues';
   name_en: 'Australian languages';
  ),
  (
   code: 'av';
   biblio_code: 'ava';
   name_fr: 'avar';
   name_en: 'Avaric';
  ),
  (
   code: 'ae';
   biblio_code: 'ave';
   name_fr: 'avestique';
   name_en: 'Avestan';
  ),
  (
   code: '';
   biblio_code: 'awa';
   name_fr: 'awadhi';
   name_en: 'Awadhi';
  ),
  (
   code: 'ay';
   biblio_code: 'aym';
   name_fr: 'aymara';
   name_en: 'Aymara';
  ),
  (
   code: 'az';
   biblio_code: 'aze';
   name_fr: 'az'#233'ri';
   name_en: 'Azerbaijani';
  ),
  (
   code: '';
   biblio_code: 'bad';
   name_fr: 'banda, langues';
   name_en: 'Banda languages';
  ),
  (
   code: '';
   biblio_code: 'bai';
   name_fr: 'bamil'#233'k'#233', langues';
   name_en: 'Bamileke languages';
  ),
  (
   code: 'ba';
   biblio_code: 'bak';
   name_fr: 'bachkir';
   name_en: 'Bashkir';
  ),
  (
   code: '';
   biblio_code: 'bal';
   name_fr: 'baloutchi';
   name_en: 'Baluchi';
  ),
  (
   code: 'bm';
   biblio_code: 'bam';
   name_fr: 'bambara';
   name_en: 'Bambara';
  ),
  (
   code: '';
   biblio_code: 'ban';
   name_fr: 'balinais';
   name_en: 'Balinese';
  ),
  (
   code: 'eu';
   biblio_code: 'baq';
   name_fr: 'basque';
   name_en: 'Basque';
  ),
  (
   code: '';
   biblio_code: 'bas';
   name_fr: 'basa';
   name_en: 'Basa';
  ),
  (
   code: '';
   biblio_code: 'bat';
   name_fr: 'baltes, langues';
   name_en: 'Baltic languages';
  ),
  (
   code: '';
   biblio_code: 'bej';
   name_fr: 'bedja';
   name_en: 'Beja; Bedawiyet';
  ),
  (
   code: 'be';
   biblio_code: 'bel';
   name_fr: 'bi'#233'lorusse';
   name_en: 'Belarusian';
  ),
  (
   code: '';
   biblio_code: 'bem';
   name_fr: 'bemba';
   name_en: 'Bemba';
  ),
  (
   code: 'bn';
   biblio_code: 'ben';
   name_fr: 'bengali';
   name_en: 'Bengali';
  ),
  (
   code: '';
   biblio_code: 'ber';
   name_fr: 'berb'#232'res, langues';
   name_en: 'Berber languages)';
  ),
  (
   code: '';
   biblio_code: 'bho';
   name_fr: 'bhojpuri';
   name_en: 'Bhojpuri';
  ),
  (
   code: 'bh';
   biblio_code: 'bih';
   name_fr: 'langues biharis';
   name_en: 'Bihari languages';
  ),
  (
   code: '';
   biblio_code: 'bik';
   name_fr: 'bikol';
   name_en: 'Bikol';
  ),
  (
   code: '';
   biblio_code: 'bin';
   name_fr: 'bini; edo';
   name_en: 'Bini; Edo';
  ),
  (
   code: 'bi';
   biblio_code: 'bis';
   name_fr: 'bichlamar';
   name_en: 'Bislama';
  ),
  (
   code: '';
   biblio_code: 'bla';
   name_fr: 'blackfoot';
   name_en: 'Siksika';
  ),
  (
   code: '';
   biblio_code: 'bnt';
   name_fr: 'bantou, langues';
   name_en: 'Bantu languages';
  ),
  (
   code: 'bs';
   biblio_code: 'bos';
   name_fr: 'bosniaque';
   name_en: 'Bosnian';
  ),
  (
   code: '';
   biblio_code: 'bra';
   name_fr: 'braj';
   name_en: 'Braj';
  ),
  (
   code: 'br';
   biblio_code: 'bre';
   name_fr: 'breton';
   name_en: 'Breton';
  ),
  (
   code: '';
   biblio_code: 'btk';
   name_fr: 'batak, langues';
   name_en: 'Batak languages';
  ),
  (
   code: '';
   biblio_code: 'bua';
   name_fr: 'bouriate';
   name_en: 'Buriat';
  ),
  (
   code: '';
   biblio_code: 'bug';
   name_fr: 'bugi';
   name_en: 'Buginese';
  ),
  (
   code: 'bg';
   biblio_code: 'bul';
   name_fr: 'bulgare';
   name_en: 'Bulgarian';
  ),
  (
   code: 'my';
   biblio_code: 'bur';
   name_fr: 'birman';
   name_en: 'Burmese';
  ),
  (
   code: '';
   biblio_code: 'byn';
   name_fr: 'blin; bilen';
   name_en: 'Blin; Bilin';
  ),
  (
   code: '';
   biblio_code: 'cad';
   name_fr: 'caddo';
   name_en: 'Caddo';
  ),
  (
   code: '';
   biblio_code: 'cai';
   name_fr: 'am'#233'rindiennes de l''''Am'#233'rique centrale, langues';
   name_en: 'Central American Indian languages';
  ),
  (
   code: '';
   biblio_code: 'car';
   name_fr: 'karib; galibi; carib';
   name_en: 'Galibi Carib';
  ),
  (
   code: 'ca';
   biblio_code: 'cat';
   name_fr: 'catalan; valencien';
   name_en: 'Catalan; Valencian';
  ),
  (
   code: '';
   biblio_code: 'cau';
   name_fr: 'caucasiennes, langues';
   name_en: 'Caucasian languages';
  ),
  (
   code: '';
   biblio_code: 'ceb';
   name_fr: 'cebuano';
   name_en: 'Cebuano';
  ),
  (
   code: '';
   biblio_code: 'cel';
   name_fr: 'celtiques, langues; celtes, langues';
   name_en: 'Celtic languages';
  ),
  (
   code: 'ch';
   biblio_code: 'cha';
   name_fr: 'chamorro';
   name_en: 'Chamorro';
  ),
  (
   code: '';
   biblio_code: 'chb';
   name_fr: 'chibcha';
   name_en: 'Chibcha';
  ),
  (
   code: 'ce';
   biblio_code: 'che';
   name_fr: 'tch'#233'tch'#232'ne';
   name_en: 'Chechen';
  ),
  (
   code: '';
   biblio_code: 'chg';
   name_fr: 'djaghata'#239'';
   name_en: 'Chagatai';
  ),
  (
   code: 'zh';
   biblio_code: 'chi';
   name_fr: 'chinois';
   name_en: 'Chinese';
  ),
  (
   code: '';
   biblio_code: 'chk';
   name_fr: 'chuuk';
   name_en: 'Chuukese';
  ),
  (
   code: '';
   biblio_code: 'chm';
   name_fr: 'mari';
   name_en: 'Mari';
  ),
  (
   code: '';
   biblio_code: 'chn';
   name_fr: 'chinook, jargon';
   name_en: 'Chinook jargon';
  ),
  (
   code: '';
   biblio_code: 'cho';
   name_fr: 'choctaw';
   name_en: 'Choctaw';
  ),
  (
   code: '';
   biblio_code: 'chp';
   name_fr: 'chipewyan';
   name_en: 'Chipewyan; Dene Suline';
  ),
  (
   code: '';
   biblio_code: 'chr';
   name_fr: 'cherokee';
   name_en: 'Cherokee';
  ),
  (
   code: 'cu';
   biblio_code: 'chu';
   name_fr: 'slavon d'''''#233'glise; vieux slave; slavon liturgique; vieux bulgare';
   name_en: 'Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic';
  ),
  (
   code: 'cv';
   biblio_code: 'chv';
   name_fr: 'tchouvache';
   name_en: 'Chuvash';
  ),
  (
   code: '';
   biblio_code: 'chy';
   name_fr: 'cheyenne';
   name_en: 'Cheyenne';
  ),
  (
   code: '';
   biblio_code: 'cmc';
   name_fr: 'chames, langues';
   name_en: 'Chamic languages';
  ),
  (
   code: '';
   biblio_code: 'cop';
   name_fr: 'copte';
   name_en: 'Coptic';
  ),
  (
   code: 'kw';
   biblio_code: 'cor';
   name_fr: 'cornique';
   name_en: 'Cornish';
  ),
  (
   code: 'co';
   biblio_code: 'cos';
   name_fr: 'corse';
   name_en: 'Corsican';
  ),
  (
   code: '';
   biblio_code: 'cpe';
   name_fr: 'cr'#233'oles et pidgins bas'#233's sur l''''anglais';
   name_en: 'Creoles and pidgins, English based';
  ),
  (
   code: '';
   biblio_code: 'cpf';
   name_fr: 'cr'#233'oles et pidgins bas'#233's sur le fran'#231'ais';
   name_en: 'Creoles and pidgins, French-based';
  ),
  (
   code: '';
   biblio_code: 'cpp';
   name_fr: 'cr'#233'oles et pidgins bas'#233's sur le portugais';
   name_en: 'Creoles and pidgins, Portuguese-based';
  ),
  (
   code: 'cr';
   biblio_code: 'cre';
   name_fr: 'cree';
   name_en: 'Cree';
  ),
  (
   code: '';
   biblio_code: 'crh';
   name_fr: 'tatar de Crim'#233'';
   name_en: 'Crimean Tatar; Crimean Turkish';
  ),
  (
   code: '';
   biblio_code: 'crp';
   name_fr: 'cr'#233'oles et pidgins';
   name_en: 'Creoles and pidgins';
  ),
  (
   code: '';
   biblio_code: 'csb';
   name_fr: 'kachoube';
   name_en: 'Kashubian';
  ),
  (
   code: '';
   biblio_code: 'cus';
   name_fr: 'couchitiques, langues';
   name_en: 'Cushitic languages';
  ),
  (
   code: 'cs';
   biblio_code: 'cze';
   name_fr: 'tch'#232'que';
   name_en: 'Czech';
  ),
  (
   code: '';
   biblio_code: 'dak';
   name_fr: 'dakota';
   name_en: 'Dakota';
  ),
  (
   code: 'da';
   biblio_code: 'dan';
   name_fr: 'danois';
   name_en: 'Danish';
  ),
  (
   code: '';
   biblio_code: 'dar';
   name_fr: 'dargwa';
   name_en: 'Dargwa';
  ),
  (
   code: '';
   biblio_code: 'day';
   name_fr: 'dayak, langues';
   name_en: 'Land Dayak languages';
  ),
  (
   code: '';
   biblio_code: 'del';
   name_fr: 'delaware';
   name_en: 'Delaware';
  ),
  (
   code: '';
   biblio_code: 'den';
   name_fr: 'esclave (athapascan)';
   name_en: 'Slave (Athapascan)';
  ),
  (
   code: '';
   biblio_code: 'dgr';
   name_fr: 'dogrib';
   name_en: 'Dogrib';
  ),
  (
   code: '';
   biblio_code: 'din';
   name_fr: 'dinka';
   name_en: 'Dinka';
  ),
  (
   code: 'dv';
   biblio_code: 'div';
   name_fr: 'maldivien';
   name_en: 'Divehi; Dhivehi; Maldivian';
  ),
  (
   code: '';
   biblio_code: 'doi';
   name_fr: 'dogri';
   name_en: 'Dogri';
  ),
  (
   code: '';
   biblio_code: 'dra';
   name_fr: 'dravidiennes,langues';
   name_en: 'Dravidian languages';
  ),
  (
   code: '';
   biblio_code: 'dsb';
   name_fr: 'bas-sorabe';
   name_en: 'Lower Sorbian';
  ),
  (
   code: '';
   biblio_code: 'dua';
   name_fr: 'douala';
   name_en: 'Duala';
  ),
  (
   code: '';
   biblio_code: 'dum';
   name_fr: 'n'#233'erlandais moyen (ca. 1050-1350)';
   name_en: 'Dutch, Middle (ca.1050-1350)';
  ),
  (
   code: 'nl';
   biblio_code: 'dut';
   name_fr: 'n'#233'erlandais; flamand';
   name_en: 'Dutch; Flemish';
  ),
  (
   code: '';
   biblio_code: 'dyu';
   name_fr: 'dioula';
   name_en: 'Dyula';
  ),
  (
   code: 'dz';
   biblio_code: 'dzo';
   name_fr: 'dzongkha';
   name_en: 'Dzongkha';
  ),
  (
   code: '';
   biblio_code: 'efi';
   name_fr: 'efik';
   name_en: 'Efik';
  ),
  (
   code: '';
   biblio_code: 'egy';
   name_fr: ''#233'gyptien';
   name_en: 'Egyptian (Ancient)';
  ),
  (
   code: '';
   biblio_code: 'eka';
   name_fr: 'ekajuk';
   name_en: 'Ekajuk';
  ),
  (
   code: '';
   biblio_code: 'elx';
   name_fr: ''#233'lamite';
   name_en: 'Elamite';
  ),
  (
   code: 'en';
   biblio_code: 'eng';
   name_fr: 'anglais';
   name_en: 'English';
  ),
  (
   code: '';
   biblio_code: 'enm';
   name_fr: 'anglais moyen (1100-1500)';
   name_en: 'English, Middle (1100-1500)';
  ),
  (
   code: 'eo';
   biblio_code: 'epo';
   name_fr: 'esp'#233'ranto';
   name_en: 'Esperanto';
  ),
  (
   code: 'et';
   biblio_code: 'est';
   name_fr: 'estonien';
   name_en: 'Estonian';
  ),
  (
   code: 'ee';
   biblio_code: 'ewe';
   name_fr: ''#233'w'#233'';
   name_en: 'Ewe';
  ),
  (
   code: '';
   biblio_code: 'ewo';
   name_fr: ''#233'wondo';
   name_en: 'Ewondo';
  ),
  (
   code: '';
   biblio_code: 'fan';
   name_fr: 'fang';
   name_en: 'Fang';
  ),
  (
   code: 'fo';
   biblio_code: 'fao';
   name_fr: 'f'#233'ro'#239'en';
   name_en: 'Faroese';
  ),
  (
   code: '';
   biblio_code: 'fat';
   name_fr: 'fanti';
   name_en: 'Fanti';
  ),
  (
   code: 'fj';
   biblio_code: 'fij';
   name_fr: 'fidjien';
   name_en: 'Fijian';
  ),
  (
   code: '';
   biblio_code: 'fil';
   name_fr: 'filipino; pilipino';
   name_en: 'Filipino; Pilipino';
  ),
  (
   code: 'fi';
   biblio_code: 'fin';
   name_fr: 'finnois';
   name_en: 'Finnish';
  ),
  (
   code: '';
   biblio_code: 'fiu';
   name_fr: 'finno-ougriennes,langues';
   name_en: 'Finno-Ugrian languages)';
  ),
  (
   code: '';
   biblio_code: 'fon';
   name_fr: 'fon';
   name_en: 'Fon';
  ),
  (
   code: 'fr';
   biblio_code: 'fre';
   name_fr: 'fran'#231'ais';
   name_en: 'French';
  ),
  (
   code: '';
   biblio_code: 'frm';
   name_fr: 'fran'#231'ais moyen (1400-1600)';
   name_en: 'French, Middle (ca.1400-1600)';
  ),
  (
   code: '';
   biblio_code: 'fro';
   name_fr: 'fran'#231'ais ancien (842-ca.1400)';
   name_en: 'French, Old (842-ca.1400)';
  ),
  (
   code: '';
   biblio_code: 'frr';
   name_fr: 'frison septentrional';
   name_en: 'Northern Frisian';
  ),
  (
   code: '';
   biblio_code: 'frs';
   name_fr: 'frison oriental';
   name_en: 'Eastern Frisian';
  ),
  (
   code: 'fy';
   biblio_code: 'fry';
   name_fr: 'frison occidental';
   name_en: 'Western Frisian';
  ),
  (
   code: 'ff';
   biblio_code: 'ful';
   name_fr: 'peul';
   name_en: 'Fulah';
  ),
  (
   code: '';
   biblio_code: 'fur';
   name_fr: 'frioulan';
   name_en: 'Friulian';
  ),
  (
   code: '';
   biblio_code: 'gaa';
   name_fr: 'ga';
   name_en: 'Ga';
  ),
  (
   code: '';
   biblio_code: 'gay';
   name_fr: 'gayo';
   name_en: 'Gayo';
  ),
  (
   code: '';
   biblio_code: 'gba';
   name_fr: 'gbaya';
   name_en: 'Gbaya';
  ),
  (
   code: '';
   biblio_code: 'gem';
   name_fr: 'germaniques, langues';
   name_en: 'Germanic languages';
  ),
  (
   code: 'ka';
   biblio_code: 'geo';
   name_fr: 'g'#233'orgien';
   name_en: 'Georgian';
  ),
  (
   code: 'de';
   biblio_code: 'ger';
   name_fr: 'allemand';
   name_en: 'German';
  ),
  (
   code: '';
   biblio_code: 'gez';
   name_fr: 'gu'#232'ze';
   name_en: 'Geez';
  ),
  (
   code: '';
   biblio_code: 'gil';
   name_fr: 'kiribati';
   name_en: 'Gilbertese';
  ),
  (
   code: 'gd';
   biblio_code: 'gla';
   name_fr: 'ga'#233'lique; ga'#233'lique '#233'cossais';
   name_en: 'Gaelic; Scottish Gaelic';
  ),
  (
   code: 'ga';
   biblio_code: 'gle';
   name_fr: 'irlandais';
   name_en: 'Irish';
  ),
  (
   code: 'gl';
   biblio_code: 'glg';
   name_fr: 'galicien';
   name_en: 'Galician';
  ),
  (
   code: 'gv';
   biblio_code: 'glv';
   name_fr: 'manx; mannois';
   name_en: 'Manx';
  ),
  (
   code: '';
   biblio_code: 'gmh';
   name_fr: 'allemand, moyen haut (ca. 1050-1500)';
   name_en: 'German, Middle High (ca.1050-1500)';
  ),
  (
   code: '';
   biblio_code: 'goh';
   name_fr: 'allemand, vieux haut (ca. 750-1050)';
   name_en: 'German, Old High (ca.750-1050)';
  ),
  (
   code: '';
   biblio_code: 'gon';
   name_fr: 'gond';
   name_en: 'Gondi';
  ),
  (
   code: '';
   biblio_code: 'gor';
   name_fr: 'gorontalo';
   name_en: 'Gorontalo';
  ),
  (
   code: '';
   biblio_code: 'got';
   name_fr: 'gothique';
   name_en: 'Gothic';
  ),
  (
   code: '';
   biblio_code: 'grb';
   name_fr: 'grebo';
   name_en: 'Grebo';
  ),
  (
   code: '';
   biblio_code: 'grc';
   name_fr: 'grec ancien (jusqu'''''#224' 1453)';
   name_en: 'Greek, Ancient (to 1453)';
  ),
  (
   code: 'el';
   biblio_code: 'gre';
   name_fr: 'grec moderne (apr'#232's 1453)';
   name_en: 'Greek, Modern (1453-)';
  ),
  (
   code: 'gn';
   biblio_code: 'grn';
   name_fr: 'guarani';
   name_en: 'Guarani';
  ),
  (
   code: '';
   biblio_code: 'gsw';
   name_fr: 'suisse al'#233'manique; al'#233'manique; alsacien';
   name_en: 'Swiss German; Alemannic; Alsatian';
  ),
  (
   code: 'gu';
   biblio_code: 'guj';
   name_fr: 'goudjrati';
   name_en: 'Gujarati';
  ),
  (
   code: '';
   biblio_code: 'gwi';
   name_fr: 'gwich''''in';
   name_en: 'Gwich''''in';
  ),
  (
   code: '';
   biblio_code: 'hai';
   name_fr: 'haida';
   name_en: 'Haida';
  ),
  (
   code: 'ht';
   biblio_code: 'hat';
   name_fr: 'ha'#239'tien; cr'#233'ole ha'#239'tien';
   name_en: 'Haitian; Haitian Creole';
  ),
  (
   code: 'ha';
   biblio_code: 'hau';
   name_fr: 'haoussa';
   name_en: 'Hausa';
  ),
  (
   code: '';
   biblio_code: 'haw';
   name_fr: 'hawa'#239'en';
   name_en: 'Hawaiian';
  ),
  (
   code: 'he';
   biblio_code: 'heb';
   name_fr: 'h'#233'breu';
   name_en: 'Hebrew';
  ),
  (
   code: 'hz';
   biblio_code: 'her';
   name_fr: 'herero';
   name_en: 'Herero';
  ),
  (
   code: '';
   biblio_code: 'hil';
   name_fr: 'hiligaynon';
   name_en: 'Hiligaynon';
  ),
  (
   code: '';
   biblio_code: 'him';
   name_fr: 'langues himachalis; langues paharis occidentales';
   name_en: 'Himachali languages; Western Pahari languages';
  ),
  (
   code: 'hi';
   biblio_code: 'hin';
   name_fr: 'hindi';
   name_en: 'Hindi';
  ),
  (
   code: '';
   biblio_code: 'hit';
   name_fr: 'hittite';
   name_en: 'Hittite';
  ),
  (
   code: '';
   biblio_code: 'hmn';
   name_fr: 'hmong';
   name_en: 'Hmong; Mong';
  ),
  (
   code: 'ho';
   biblio_code: 'hmo';
   name_fr: 'hiri motu';
   name_en: 'Hiri Motu';
  ),
  (
   code: 'hr';
   biblio_code: 'hrv';
   name_fr: 'croate';
   name_en: 'Croatian';
  ),
  (
   code: '';
   biblio_code: 'hsb';
   name_fr: 'haut-sorabe';
   name_en: 'Upper Sorbian';
  ),
  (
   code: 'hu';
   biblio_code: 'hun';
   name_fr: 'hongrois';
   name_en: 'Hungarian';
  ),
  (
   code: '';
   biblio_code: 'hup';
   name_fr: 'hupa';
   name_en: 'Hupa';
  ),
  (
   code: '';
   biblio_code: 'iba';
   name_fr: 'iban';
   name_en: 'Iban';
  ),
  (
   code: 'ig';
   biblio_code: 'ibo';
   name_fr: 'igbo';
   name_en: 'Igbo';
  ),
  (
   code: 'is';
   biblio_code: 'ice';
   name_fr: 'islandais';
   name_en: 'Icelandic';
  ),
  (
   code: 'io';
   biblio_code: 'ido';
   name_fr: 'ido';
   name_en: 'Ido';
  ),
  (
   code: 'ii';
   biblio_code: 'iii';
   name_fr: 'yi de Sichuan';
   name_en: 'Sichuan Yi; Nuosu';
  ),
  (
   code: '';
   biblio_code: 'ijo';
   name_fr: 'ijo, langues';
   name_en: 'Ijo languages';
  ),
  (
   code: 'iu';
   biblio_code: 'iku';
   name_fr: 'inuktitut';
   name_en: 'Inuktitut';
  ),
  (
   code: 'ie';
   biblio_code: 'ile';
   name_fr: 'interlingue';
   name_en: 'Interlingue; Occidental';
  ),
  (
   code: '';
   biblio_code: 'ilo';
   name_fr: 'ilocano';
   name_en: 'Iloko';
  ),
  (
   code: 'ia';
   biblio_code: 'ina';
   name_fr: 'interlingua (langue auxiliaire internationale)';
   name_en: 'Interlingua (International Auxiliary Language Association)';
  ),
  (
   code: '';
   biblio_code: 'inc';
   name_fr: 'indo-aryennes, langues';
   name_en: 'Indic languages';
  ),
  (
   code: 'id';
   biblio_code: 'ind';
   name_fr: 'indon'#233'sien';
   name_en: 'Indonesian';
  ),
  (
   code: '';
   biblio_code: 'ine';
   name_fr: 'indo-europ'#233'ennes, langues';
   name_en: 'Indo-European languages';
  ),
  (
   code: '';
   biblio_code: 'inh';
   name_fr: 'ingouche';
   name_en: 'Ingush';
  ),
  (
   code: 'ik';
   biblio_code: 'ipk';
   name_fr: 'inupiaq';
   name_en: 'Inupiaq';
  ),
  (
   code: '';
   biblio_code: 'ira';
   name_fr: 'iraniennes, langues';
   name_en: 'Iranian languages';
  ),
  (
   code: '';
   biblio_code: 'iro';
   name_fr: 'iroquoises, langues';
   name_en: 'Iroquoian languages';
  ),
  (
   code: 'it';
   biblio_code: 'ita';
   name_fr: 'italien';
   name_en: 'Italian';
  ),
  (
   code: 'jv';
   biblio_code: 'jav';
   name_fr: 'javanais';
   name_en: 'Javanese';
  ),
  (
   code: '';
   biblio_code: 'jbo';
   name_fr: 'lojban';
   name_en: 'Lojban';
  ),
  (
   code: 'ja';
   biblio_code: 'jpn';
   name_fr: 'japonais';
   name_en: 'Japanese';
  ),
  (
   code: '';
   biblio_code: 'jpr';
   name_fr: 'jud'#233'o-persan';
   name_en: 'Judeo-Persian';
  ),
  (
   code: '';
   biblio_code: 'jrb';
   name_fr: 'jud'#233'o-arabe';
   name_en: 'Judeo-Arabic';
  ),
  (
   code: '';
   biblio_code: 'kaa';
   name_fr: 'karakalpak';
   name_en: 'Kara-Kalpak';
  ),
  (
   code: '';
   biblio_code: 'kab';
   name_fr: 'kabyle';
   name_en: 'Kabyle';
  ),
  (
   code: '';
   biblio_code: 'kac';
   name_fr: 'kachin; jingpho';
   name_en: 'Kachin; Jingpho';
  ),
  (
   code: 'kl';
   biblio_code: 'kal';
   name_fr: 'groenlandais';
   name_en: 'Kalaallisut; Greenlandic';
  ),
  (
   code: '';
   biblio_code: 'kam';
   name_fr: 'kamba';
   name_en: 'Kamba';
  ),
  (
   code: 'kn';
   biblio_code: 'kan';
   name_fr: 'kannada';
   name_en: 'Kannada';
  ),
  (
   code: '';
   biblio_code: 'kar';
   name_fr: 'karen, langues';
   name_en: 'Karen languages';
  ),
  (
   code: 'ks';
   biblio_code: 'kas';
   name_fr: 'kashmiri';
   name_en: 'Kashmiri';
  ),
  (
   code: 'kr';
   biblio_code: 'kau';
   name_fr: 'kanouri';
   name_en: 'Kanuri';
  ),
  (
   code: '';
   biblio_code: 'kaw';
   name_fr: 'kawi';
   name_en: 'Kawi';
  ),
  (
   code: 'kk';
   biblio_code: 'kaz';
   name_fr: 'kazakh';
   name_en: 'Kazakh';
  ),
  (
   code: '';
   biblio_code: 'kbd';
   name_fr: 'kabardien';
   name_en: 'Kabardian';
  ),
  (
   code: '';
   biblio_code: 'kha';
   name_fr: 'khasi';
   name_en: 'Khasi';
  ),
  (
   code: '';
   biblio_code: 'khi';
   name_fr: 'kho'#239'san, langues';
   name_en: 'Khoisan languages';
  ),
  (
   code: 'km';
   biblio_code: 'khm';
   name_fr: 'khmer central';
   name_en: 'Central Khmer';
  ),
  (
   code: '';
   biblio_code: 'kho';
   name_fr: 'khotanais; sakan';
   name_en: 'Khotanese; Sakan';
  ),
  (
   code: 'ki';
   biblio_code: 'kik';
   name_fr: 'kikuyu';
   name_en: 'Kikuyu; Gikuyu';
  ),
  (
   code: 'rw';
   biblio_code: 'kin';
   name_fr: 'rwanda';
   name_en: 'Kinyarwanda';
  ),
  (
   code: 'ky';
   biblio_code: 'kir';
   name_fr: 'kirghiz';
   name_en: 'Kirghiz; Kyrgyz';
  ),
  (
   code: '';
   biblio_code: 'kmb';
   name_fr: 'kimbundu';
   name_en: 'Kimbundu';
  ),
  (
   code: '';
   biblio_code: 'kok';
   name_fr: 'konkani';
   name_en: 'Konkani';
  ),
  (
   code: 'kv';
   biblio_code: 'kom';
   name_fr: 'kom';
   name_en: 'Komi';
  ),
  (
   code: 'kg';
   biblio_code: 'kon';
   name_fr: 'kongo';
   name_en: 'Kongo';
  ),
  (
   code: 'ko';
   biblio_code: 'kor';
   name_fr: 'cor'#233'en';
   name_en: 'Korean';
  ),
  (
   code: '';
   biblio_code: 'kos';
   name_fr: 'kosrae';
   name_en: 'Kosraean';
  ),
  (
   code: '';
   biblio_code: 'kpe';
   name_fr: 'kpell'#233'';
   name_en: 'Kpelle';
  ),
  (
   code: '';
   biblio_code: 'krc';
   name_fr: 'karatchai balkar';
   name_en: 'Karachay-Balkar';
  ),
  (
   code: '';
   biblio_code: 'krl';
   name_fr: 'car'#233'lien';
   name_en: 'Karelian';
  ),
  (
   code: '';
   biblio_code: 'kro';
   name_fr: 'krou, langues';
   name_en: 'Kru languages';
  ),
  (
   code: '';
   biblio_code: 'kru';
   name_fr: 'kurukh';
   name_en: 'Kurukh';
  ),
  (
   code: 'kj';
   biblio_code: 'kua';
   name_fr: 'kuanyama; kwanyama';
   name_en: 'Kuanyama; Kwanyama';
  ),
  (
   code: '';
   biblio_code: 'kum';
   name_fr: 'koumyk';
   name_en: 'Kumyk';
  ),
  (
   code: 'ku';
   biblio_code: 'kur';
   name_fr: 'kurde';
   name_en: 'Kurdish';
  ),
  (
   code: '';
   biblio_code: 'kut';
   name_fr: 'kutenai';
   name_en: 'Kutenai';
  ),
  (
   code: '';
   biblio_code: 'lad';
   name_fr: 'jud'#233'o-espagnol';
   name_en: 'Ladino';
  ),
  (
   code: '';
   biblio_code: 'lah';
   name_fr: 'lahnda';
   name_en: 'Lahnda';
  ),
  (
   code: '';
   biblio_code: 'lam';
   name_fr: 'lamba';
   name_en: 'Lamba';
  ),
  (
   code: 'lo';
   biblio_code: 'lao';
   name_fr: 'lao';
   name_en: 'Lao';
  ),
  (
   code: 'la';
   biblio_code: 'lat';
   name_fr: 'latin';
   name_en: 'Latin';
  ),
  (
   code: 'lv';
   biblio_code: 'lav';
   name_fr: 'letton';
   name_en: 'Latvian';
  ),
  (
   code: '';
   biblio_code: 'lez';
   name_fr: 'lezghien';
   name_en: 'Lezghian';
  ),
  (
   code: 'li';
   biblio_code: 'lim';
   name_fr: 'limbourgeois';
   name_en: 'Limburgan; Limburger; Limburgish';
  ),
  (
   code: 'ln';
   biblio_code: 'lin';
   name_fr: 'lingala';
   name_en: 'Lingala';
  ),
  (
   code: 'lt';
   biblio_code: 'lit';
   name_fr: 'lituanien';
   name_en: 'Lithuanian';
  ),
  (
   code: '';
   biblio_code: 'lol';
   name_fr: 'mongo';
   name_en: 'Mongo';
  ),
  (
   code: '';
   biblio_code: 'loz';
   name_fr: 'lozi';
   name_en: 'Lozi';
  ),
  (
   code: 'lb';
   biblio_code: 'ltz';
   name_fr: 'luxembourgeois';
   name_en: 'Luxembourgish; Letzeburgesch';
  ),
  (
   code: '';
   biblio_code: 'lua';
   name_fr: 'luba-lulua';
   name_en: 'Luba-Lulua';
  ),
  (
   code: 'lu';
   biblio_code: 'lub';
   name_fr: 'luba-katanga';
   name_en: 'Luba-Katanga';
  ),
  (
   code: 'lg';
   biblio_code: 'lug';
   name_fr: 'ganda';
   name_en: 'Ganda';
  ),
  (
   code: '';
   biblio_code: 'lui';
   name_fr: 'luiseno';
   name_en: 'Luiseno';
  ),
  (
   code: '';
   biblio_code: 'lun';
   name_fr: 'lunda';
   name_en: 'Lunda';
  ),
  (
   code: '';
   biblio_code: 'luo';
   name_fr: 'luo (Kenya et Tanzanie)';
   name_en: 'Luo (Kenya and Tanzania)';
  ),
  (
   code: '';
   biblio_code: 'lus';
   name_fr: 'lushai';
   name_en: 'Lushai';
  ),
  (
   code: 'mk';
   biblio_code: 'mac';
   name_fr: 'mac'#233'donien';
   name_en: 'Macedonian';
  ),
  (
   code: '';
   biblio_code: 'mad';
   name_fr: 'madourais';
   name_en: 'Madurese';
  ),
  (
   code: '';
   biblio_code: 'mag';
   name_fr: 'magahi';
   name_en: 'Magahi';
  ),
  (
   code: 'mh';
   biblio_code: 'mah';
   name_fr: 'marshall';
   name_en: 'Marshallese';
  ),
  (
   code: '';
   biblio_code: 'mai';
   name_fr: 'maithili';
   name_en: 'Maithili';
  ),
  (
   code: '';
   biblio_code: 'mak';
   name_fr: 'makassar';
   name_en: 'Makasar';
  ),
  (
   code: 'ml';
   biblio_code: 'mal';
   name_fr: 'malayalam';
   name_en: 'Malayalam';
  ),
  (
   code: '';
   biblio_code: 'man';
   name_fr: 'mandingue';
   name_en: 'Mandingo';
  ),
  (
   code: 'mi';
   biblio_code: 'mao';
   name_fr: 'maori';
   name_en: 'Maori';
  ),
  (
   code: '';
   biblio_code: 'map';
   name_fr: 'austron'#233'siennes, langues';
   name_en: 'Austronesian languages';
  ),
  (
   code: 'mr';
   biblio_code: 'mar';
   name_fr: 'marathe';
   name_en: 'Marathi';
  ),
  (
   code: '';
   biblio_code: 'mas';
   name_fr: 'massa'#239'';
   name_en: 'Masai';
  ),
  (
   code: 'ms';
   biblio_code: 'may';
   name_fr: 'malais';
   name_en: 'Malay';
  ),
  (
   code: '';
   biblio_code: 'mdf';
   name_fr: 'moksa';
   name_en: 'Moksha';
  ),
  (
   code: '';
   biblio_code: 'mdr';
   name_fr: 'mandar';
   name_en: 'Mandar';
  ),
  (
   code: '';
   biblio_code: 'men';
   name_fr: 'mend'#233'';
   name_en: 'Mende';
  ),
  (
   code: '';
   biblio_code: 'mga';
   name_fr: 'irlandais moyen (900-1200)';
   name_en: 'Irish, Middle (900-1200)';
  ),
  (
   code: '';
   biblio_code: 'mic';
   name_fr: 'mi''''kmaq; micmac';
   name_en: 'Mi''''kmaq; Micmac';
  ),
  (
   code: '';
   biblio_code: 'min';
   name_fr: 'minangkabau';
   name_en: 'Minangkabau';
  ),
  (
   code: '';
   biblio_code: 'mis';
   name_fr: 'langues non cod'#233'es';
   name_en: 'Uncoded languages';
  ),
  (
   code: '';
   biblio_code: 'mkh';
   name_fr: 'm'#244'n-khmer, langues';
   name_en: 'Mon-Khmer languages';
  ),
  (
   code: 'mg';
   biblio_code: 'mlg';
   name_fr: 'malgache';
   name_en: 'Malagasy';
  ),
  (
   code: 'mt';
   biblio_code: 'mlt';
   name_fr: 'maltais';
   name_en: 'Maltese';
  ),
  (
   code: '';
   biblio_code: 'mnc';
   name_fr: 'mandchou';
   name_en: 'Manchu';
  ),
  (
   code: '';
   biblio_code: 'mni';
   name_fr: 'manipuri';
   name_en: 'Manipuri';
  ),
  (
   code: '';
   biblio_code: 'mno';
   name_fr: 'manobo, langues';
   name_en: 'Manobo languages';
  ),
  (
   code: '';
   biblio_code: 'moh';
   name_fr: 'mohawk';
   name_en: 'Mohawk';
  ),
  (
   code: 'mn';
   biblio_code: 'mon';
   name_fr: 'mongol';
   name_en: 'Mongolian';
  ),
  (
   code: '';
   biblio_code: 'mos';
   name_fr: 'mor'#233'';
   name_en: 'Mossi';
  ),
  (
   code: '';
   biblio_code: 'mul';
   name_fr: 'multilingue';
   name_en: 'Multiple languages';
  ),
  (
   code: '';
   biblio_code: 'mun';
   name_fr: 'mounda, langues';
   name_en: 'Munda languages';
  ),
  (
   code: '';
   biblio_code: 'mus';
   name_fr: 'muskogee';
   name_en: 'Creek';
  ),
  (
   code: '';
   biblio_code: 'mwl';
   name_fr: 'mirandais';
   name_en: 'Mirandese';
  ),
  (
   code: '';
   biblio_code: 'mwr';
   name_fr: 'marvari';
   name_en: 'Marwari';
  ),
  (
   code: '';
   biblio_code: 'myn';
   name_fr: 'maya, langues';
   name_en: 'Mayan languages';
  ),
  (
   code: '';
   biblio_code: 'myv';
   name_fr: 'erza';
   name_en: 'Erzya';
  ),
  (
   code: '';
   biblio_code: 'nah';
   name_fr: 'nahuatl, langues';
   name_en: 'Nahuatl languages';
  ),
  (
   code: '';
   biblio_code: 'nai';
   name_fr: 'nordam'#233'rindiennes, langues';
   name_en: 'North American Indian languages';
  ),
  (
   code: '';
   biblio_code: 'nap';
   name_fr: 'napolitain';
   name_en: 'Neapolitan';
  ),
  (
   code: 'na';
   biblio_code: 'nau';
   name_fr: 'nauruan';
   name_en: 'Nauru';
  ),
  (
   code: 'nv';
   biblio_code: 'nav';
   name_fr: 'navaho';
   name_en: 'Navajo; Navaho';
  ),
  (
   code: 'nr';
   biblio_code: 'nbl';
   name_fr: 'nd'#233'b'#233'l'#233' du Sud';
   name_en: 'Ndebele, South; South Ndebele';
  ),
  (
   code: 'nd';
   biblio_code: 'nde';
   name_fr: 'nd'#233'b'#233'l'#233' du Nord';
   name_en: 'Ndebele, North; North Ndebele';
  ),
  (
   code: 'ng';
   biblio_code: 'ndo';
   name_fr: 'ndonga';
   name_en: 'Ndonga';
  ),
  (
   code: '';
   biblio_code: 'nds';
   name_fr: 'bas allemand; bas saxon; allemand, bas; saxon, bas';
   name_en: 'Low German; Low Saxon; German, Low; Saxon, Low';
  ),
  (
   code: 'ne';
   biblio_code: 'nep';
   name_fr: 'n'#233'palais';
   name_en: 'Nepali';
  ),
  (
   code: '';
   biblio_code: 'new';
   name_fr: 'nepal bhasa; newari';
   name_en: 'Nepal Bhasa; Newari';
  ),
  (
   code: '';
   biblio_code: 'nia';
   name_fr: 'nias';
   name_en: 'Nias';
  ),
  (
   code: '';
   biblio_code: 'nic';
   name_fr: 'nig'#233'ro-kordofaniennes, langues';
   name_en: 'Niger-Kordofanian languages';
  ),
  (
   code: '';
   biblio_code: 'niu';
   name_fr: 'niu'#233'';
   name_en: 'Niuean';
  ),
  (
   code: 'nn';
   biblio_code: 'nno';
   name_fr: 'norv'#233'gien nynorsk; nynorsk, norv'#233'gien';
   name_en: 'Norwegian Nynorsk; Nynorsk, Norwegian';
  ),
  (
   code: 'nb';
   biblio_code: 'nob';
   name_fr: 'norv'#233'gien bokm'#229'l';
   name_en: 'Bokm'#229'l, Norwegian; Norwegian Bokm'#229'l';
  ),
  (
   code: '';
   biblio_code: 'nog';
   name_fr: 'noga'#239'; nogay';
   name_en: 'Nogai';
  ),
  (
   code: '';
   biblio_code: 'non';
   name_fr: 'norrois, vieux';
   name_en: 'Norse, Old';
  ),
  (
   code: 'no';
   biblio_code: 'nor';
   name_fr: 'norv'#233'gien';
   name_en: 'Norwegian';
  ),
  (
   code: '';
   biblio_code: 'nqo';
   name_fr: 'n''''ko';
   name_en: 'N''''Ko';
  ),
  (
   code: '';
   biblio_code: 'nso';
   name_fr: 'pedi; sepedi; sotho du Nord';
   name_en: 'Pedi; Sepedi; Northern Sotho';
  ),
  (
   code: '';
   biblio_code: 'nub';
   name_fr: 'nubiennes, langues';
   name_en: 'Nubian languages';
  ),
  (
   code: '';
   biblio_code: 'nwc';
   name_fr: 'newari classique';
   name_en: 'Classical Newari; Old Newari; Classical Nepal Bhasa';
  ),
  (
   code: 'ny';
   biblio_code: 'nya';
   name_fr: 'chichewa; chewa; nyanja';
   name_en: 'Chichewa; Chewa; Nyanja';
  ),
  (
   code: '';
   biblio_code: 'nym';
   name_fr: 'nyamwezi';
   name_en: 'Nyamwezi';
  ),
  (
   code: '';
   biblio_code: 'nyn';
   name_fr: 'nyankol'#233'';
   name_en: 'Nyankole';
  ),
  (
   code: '';
   biblio_code: 'nyo';
   name_fr: 'nyoro';
   name_en: 'Nyoro';
  ),
  (
   code: '';
   biblio_code: 'nzi';
   name_fr: 'nzema';
   name_en: 'Nzima';
  ),
  (
   code: 'oc';
   biblio_code: 'oci';
   name_fr: 'occitan (apr'#232's 1500)';
   name_en: 'Occitan (post 1500)';
  ),
  (
   code: 'oj';
   biblio_code: 'oji';
   name_fr: 'ojibwa';
   name_en: 'Ojibwa';
  ),
  (
   code: 'or';
   biblio_code: 'ori';
   name_fr: 'oriya';
   name_en: 'Oriya';
  ),
  (
   code: 'om';
   biblio_code: 'orm';
   name_fr: 'galla';
   name_en: 'Oromo';
  ),
  (
   code: '';
   biblio_code: 'osa';
   name_fr: 'osage';
   name_en: 'Osage';
  ),
  (
   code: 'os';
   biblio_code: 'oss';
   name_fr: 'oss'#232'te';
   name_en: 'Ossetian; Ossetic';
  ),
  (
   code: '';
   biblio_code: 'ota';
   name_fr: 'turc ottoman (1500-1928)';
   name_en: 'Turkish, Ottoman (1500-1928)';
  ),
  (
   code: '';
   biblio_code: 'oto';
   name_fr: 'otomi, langues';
   name_en: 'Otomian languages';
  ),
  (
   code: '';
   biblio_code: 'paa';
   name_fr: 'papoues, langues';
   name_en: 'Papuan languages';
  ),
  (
   code: '';
   biblio_code: 'pag';
   name_fr: 'pangasinan';
   name_en: 'Pangasinan';
  ),
  (
   code: '';
   biblio_code: 'pal';
   name_fr: 'pahlavi';
   name_en: 'Pahlavi';
  ),
  (
   code: '';
   biblio_code: 'pam';
   name_fr: 'pampangan';
   name_en: 'Pampanga; Kapampangan';
  ),
  (
   code: 'pa';
   biblio_code: 'pan';
   name_fr: 'pendjabi';
   name_en: 'Panjabi; Punjabi';
  ),
  (
   code: '';
   biblio_code: 'pap';
   name_fr: 'papiamento';
   name_en: 'Papiamento';
  ),
  (
   code: '';
   biblio_code: 'pau';
   name_fr: 'palau';
   name_en: 'Palauan';
  ),
  (
   code: '';
   biblio_code: 'peo';
   name_fr: 'perse, vieux (ca. 600-400 av. J.-C.)';
   name_en: 'Persian, Old (ca.600-400 B.C.)';
  ),
  (
   code: 'fa';
   biblio_code: 'per';
   name_fr: 'persan';
   name_en: 'Persian';
  ),
  (
   code: '';
   biblio_code: 'phi';
   name_fr: 'philippines, langues';
   name_en: 'Philippine languages)';
  ),
  (
   code: '';
   biblio_code: 'phn';
   name_fr: 'ph'#233'nicien';
   name_en: 'Phoenician';
  ),
  (
   code: 'pi';
   biblio_code: 'pli';
   name_fr: 'pali';
   name_en: 'Pali';
  ),
  (
   code: 'pl';
   biblio_code: 'pol';
   name_fr: 'polonais';
   name_en: 'Polish';
  ),
  (
   code: '';
   biblio_code: 'pon';
   name_fr: 'pohnpei';
   name_en: 'Pohnpeian';
  ),
  (
   code: 'pt';
   biblio_code: 'por';
   name_fr: 'portugais';
   name_en: 'Portuguese';
  ),
  (
   code: '';
   biblio_code: 'pra';
   name_fr: 'pr'#226'krit, langues';
   name_en: 'Prakrit languages';
  ),
  (
   code: '';
   biblio_code: 'pro';
   name_fr: 'proven'#231'al ancien (jusqu'''''#224' 1500); occitan ancien (jusqu'''''#224' 1500)';
   name_en: 'Proven'#231'al, Old (to 1500);Occitan, Old (to 1500)';
  ),
  (
   code: 'ps';
   biblio_code: 'pus';
   name_fr: 'pachto';
   name_en: 'Pushto; Pashto';
  ),
  (
   code: '';
   biblio_code: 'qaa';
   name_fr: 'r'#233'serv'#233'e '#224' l''''usage local';
   name_en: 'Reserved for local use';
  ),
  (
   code: 'qu';
   biblio_code: 'que';
   name_fr: 'quechua';
   name_en: 'Quechua';
  ),
  (
   code: '';
   biblio_code: 'raj';
   name_fr: 'rajasthani';
   name_en: 'Rajasthani';
  ),
  (
   code: '';
   biblio_code: 'rap';
   name_fr: 'rapanui';
   name_en: 'Rapanui';
  ),
  (
   code: '';
   biblio_code: 'rar';
   name_fr: 'rarotonga; maori des '#238'les Cook';
   name_en: 'Rarotongan; Cook Islands Maori';
  ),
  (
   code: '';
   biblio_code: 'roa';
   name_fr: 'romanes, langues';
   name_en: 'Romance languages';
  ),
  (
   code: 'rm';
   biblio_code: 'roh';
   name_fr: 'romanche';
   name_en: 'Romansh';
  ),
  (
   code: '';
   biblio_code: 'rom';
   name_fr: 'tsigane';
   name_en: 'Romany';
  ),
  (
   code: 'ro';
   biblio_code: 'rum';
   name_fr: 'roumain; moldave';
   name_en: 'Romanian; Moldavian; Moldovan';
  ),
  (
   code: 'rn';
   biblio_code: 'run';
   name_fr: 'rundi';
   name_en: 'Rundi';
  ),
  (
   code: '';
   biblio_code: 'rup';
   name_fr: 'aroumain; mac'#233'do-roumain';
   name_en: 'Aromanian; Arumanian; Macedo-Romanian';
  ),
  (
   code: 'ru';
   biblio_code: 'rus';
   name_fr: 'russe';
   name_en: 'Russian';
  ),
  (
   code: '';
   biblio_code: 'sad';
   name_fr: 'sandawe';
   name_en: 'Sandawe';
  ),
  (
   code: 'sg';
   biblio_code: 'sag';
   name_fr: 'sango';
   name_en: 'Sango';
  ),
  (
   code: '';
   biblio_code: 'sah';
   name_fr: 'iakoute';
   name_en: 'Yakut';
  ),
  (
   code: '';
   biblio_code: 'sai';
   name_fr: 'sud-am'#233'rindiennes, langues';
   name_en: 'South American Indian languages';
  ),
  (
   code: '';
   biblio_code: 'sal';
   name_fr: 'salishennes, langues';
   name_en: 'Salishan languages';
  ),
  (
   code: '';
   biblio_code: 'sam';
   name_fr: 'samaritain';
   name_en: 'Samaritan Aramaic';
  ),
  (
   code: 'sa';
   biblio_code: 'san';
   name_fr: 'sanskrit';
   name_en: 'Sanskrit';
  ),
  (
   code: '';
   biblio_code: 'sas';
   name_fr: 'sasak';
   name_en: 'Sasak';
  ),
  (
   code: '';
   biblio_code: 'sat';
   name_fr: 'santal';
   name_en: 'Santali';
  ),
  (
   code: '';
   biblio_code: 'scn';
   name_fr: 'sicilien';
   name_en: 'Sicilian';
  ),
  (
   code: '';
   biblio_code: 'sco';
   name_fr: ''#233'cossais';
   name_en: 'Scots';
  ),
  (
   code: '';
   biblio_code: 'sel';
   name_fr: 'selkoupe';
   name_en: 'Selkup';
  ),
  (
   code: '';
   biblio_code: 'sem';
   name_fr: 's'#233'mitiques, langues';
   name_en: 'Semitic languages';
  ),
  (
   code: '';
   biblio_code: 'sga';
   name_fr: 'irlandais ancien (jusqu'''''#224' 900)';
   name_en: 'Irish, Old (to 900)';
  ),
  (
   code: '';
   biblio_code: 'sgn';
   name_fr: 'langues des signes';
   name_en: 'Sign Languages';
  ),
  (
   code: '';
   biblio_code: 'shn';
   name_fr: 'chan';
   name_en: 'Shan';
  ),
  (
   code: '';
   biblio_code: 'sid';
   name_fr: 'sidamo';
   name_en: 'Sidamo';
  ),
  (
   code: 'si';
   biblio_code: 'sin';
   name_fr: 'singhalais';
   name_en: 'Sinhala; Sinhalese';
  ),
  (
   code: '';
   biblio_code: 'sio';
   name_fr: 'sioux, langues';
   name_en: 'Siouan languages';
  ),
  (
   code: '';
   biblio_code: 'sit';
   name_fr: 'sino-tib'#233'taines, langues';
   name_en: 'Sino-Tibetan languages';
  ),
  (
   code: '';
   biblio_code: 'sla';
   name_fr: 'slaves, langues';
   name_en: 'Slavic languages';
  ),
  (
   code: 'sk';
   biblio_code: 'slo';
   name_fr: 'slovaque';
   name_en: 'Slovak';
  ),
  (
   code: 'sl';
   biblio_code: 'slv';
   name_fr: 'slov'#232'ne';
   name_en: 'Slovenian';
  ),
  (
   code: '';
   biblio_code: 'sma';
   name_fr: 'sami du Sud';
   name_en: 'Southern Sami';
  ),
  (
   code: 'se';
   biblio_code: 'sme';
   name_fr: 'sami du Nord';
   name_en: 'Northern Sami';
  ),
  (
   code: '';
   biblio_code: 'smi';
   name_fr: 'sames, langues';
   name_en: 'Sami languages';
  ),
  (
   code: '';
   biblio_code: 'smj';
   name_fr: 'sami de Lule';
   name_en: 'Lule Sami';
  ),
  (
   code: '';
   biblio_code: 'smn';
   name_fr: 'sami d''''Inari';
   name_en: 'Inari Sami';
  ),
  (
   code: 'sm';
   biblio_code: 'smo';
   name_fr: 'samoan';
   name_en: 'Samoan';
  ),
  (
   code: '';
   biblio_code: 'sms';
   name_fr: 'sami skolt';
   name_en: 'Skolt Sami';
  ),
  (
   code: 'sn';
   biblio_code: 'sna';
   name_fr: 'shona';
   name_en: 'Shona';
  ),
  (
   code: 'sd';
   biblio_code: 'snd';
   name_fr: 'sindhi';
   name_en: 'Sindhi';
  ),
  (
   code: '';
   biblio_code: 'snk';
   name_fr: 'sonink'#233'';
   name_en: 'Soninke';
  ),
  (
   code: '';
   biblio_code: 'sog';
   name_fr: 'sogdien';
   name_en: 'Sogdian';
  ),
  (
   code: 'so';
   biblio_code: 'som';
   name_fr: 'somali';
   name_en: 'Somali';
  ),
  (
   code: '';
   biblio_code: 'son';
   name_fr: 'songhai, langues';
   name_en: 'Songhai languages';
  ),
  (
   code: 'st';
   biblio_code: 'sot';
   name_fr: 'sotho du Sud';
   name_en: 'Sotho, Southern';
  ),
  (
   code: 'es';
   biblio_code: 'spa';
   name_fr: 'espagnol; castillan';
   name_en: 'Spanish; Castilian';
  ),
  (
   code: 'sc';
   biblio_code: 'srd';
   name_fr: 'sarde';
   name_en: 'Sardinian';
  ),
  (
   code: '';
   biblio_code: 'srn';
   name_fr: 'sranan tongo';
   name_en: 'Sranan Tongo';
  ),
  (
   code: 'sr';
   biblio_code: 'srp';
   name_fr: 'serbe';
   name_en: 'Serbian';
  ),
  (
   code: '';
   biblio_code: 'srr';
   name_fr: 's'#233'r'#232're';
   name_en: 'Serer';
  ),
  (
   code: '';
   biblio_code: 'ssa';
   name_fr: 'nilo-sahariennes, langues';
   name_en: 'Nilo-Saharan languages';
  ),
  (
   code: 'ss';
   biblio_code: 'ssw';
   name_fr: 'swati';
   name_en: 'Swati';
  ),
  (
   code: '';
   biblio_code: 'suk';
   name_fr: 'sukuma';
   name_en: 'Sukuma';
  ),
  (
   code: 'su';
   biblio_code: 'sun';
   name_fr: 'soundanais';
   name_en: 'Sundanese';
  ),
  (
   code: '';
   biblio_code: 'sus';
   name_fr: 'soussou';
   name_en: 'Susu';
  ),
  (
   code: '';
   biblio_code: 'sux';
   name_fr: 'sum'#233'rien';
   name_en: 'Sumerian';
  ),
  (
   code: 'sw';
   biblio_code: 'swa';
   name_fr: 'swahili';
   name_en: 'Swahili';
  ),
  (
   code: 'sv';
   biblio_code: 'swe';
   name_fr: 'su'#233'dois';
   name_en: 'Swedish';
  ),
  (
   code: '';
   biblio_code: 'syc';
   name_fr: 'syriaque classique';
   name_en: 'Classical Syriac';
  ),
  (
   code: '';
   biblio_code: 'syr';
   name_fr: 'syriaque';
   name_en: 'Syriac';
  ),
  (
   code: 'ty';
   biblio_code: 'tah';
   name_fr: 'tahitien';
   name_en: 'Tahitian';
  ),
  (
   code: '';
   biblio_code: 'tai';
   name_fr: 'tai, langues';
   name_en: 'Tai languages';
  ),
  (
   code: 'ta';
   biblio_code: 'tam';
   name_fr: 'tamoul';
   name_en: 'Tamil';
  ),
  (
   code: 'tt';
   biblio_code: 'tat';
   name_fr: 'tatar';
   name_en: 'Tatar';
  ),
  (
   code: 'te';
   biblio_code: 'tel';
   name_fr: 't'#233'lougou';
   name_en: 'Telugu';
  ),
  (
   code: '';
   biblio_code: 'tem';
   name_fr: 'temne';
   name_en: 'Timne';
  ),
  (
   code: '';
   biblio_code: 'ter';
   name_fr: 'tereno';
   name_en: 'Tereno';
  ),
  (
   code: '';
   biblio_code: 'tet';
   name_fr: 'tetum';
   name_en: 'Tetum';
  ),
  (
   code: 'tg';
   biblio_code: 'tgk';
   name_fr: 'tadjik';
   name_en: 'Tajik';
  ),
  (
   code: 'tl';
   biblio_code: 'tgl';
   name_fr: 'tagalog';
   name_en: 'Tagalog';
  ),
  (
   code: 'th';
   biblio_code: 'tha';
   name_fr: 'tha'#239'';
   name_en: 'Thai';
  ),
  (
   code: 'bo';
   biblio_code: 'tib';
   name_fr: 'tib'#233'tain';
   name_en: 'Tibetan';
  ),
  (
   code: '';
   biblio_code: 'tig';
   name_fr: 'tigr'#233'';
   name_en: 'Tigre';
  ),
  (
   code: 'ti';
   biblio_code: 'tir';
   name_fr: 'tigrigna';
   name_en: 'Tigrinya';
  ),
  (
   code: '';
   biblio_code: 'tiv';
   name_fr: 'tiv';
   name_en: 'Tiv';
  ),
  (
   code: '';
   biblio_code: 'tkl';
   name_fr: 'tokelau';
   name_en: 'Tokelau';
  ),
  (
   code: '';
   biblio_code: 'tlh';
   name_fr: 'klingon';
   name_en: 'Klingon; tlhIngan-Hol';
  ),
  (
   code: '';
   biblio_code: 'tli';
   name_fr: 'tlingit';
   name_en: 'Tlingit';
  ),
  (
   code: '';
   biblio_code: 'tmh';
   name_fr: 'tamacheq';
   name_en: 'Tamashek';
  ),
  (
   code: '';
   biblio_code: 'tog';
   name_fr: 'tonga (Nyasa)';
   name_en: 'Tonga (Nyasa)';
  ),
  (
   code: 'to';
   biblio_code: 'ton';
   name_fr: 'tongan ('#206'les Tonga)';
   name_en: 'Tonga (Tonga Islands)';
  ),
  (
   code: '';
   biblio_code: 'tpi';
   name_fr: 'tok pisin';
   name_en: 'Tok Pisin';
  ),
  (
   code: '';
   biblio_code: 'tsi';
   name_fr: 'tsimshian';
   name_en: 'Tsimshian';
  ),
  (
   code: 'tn';
   biblio_code: 'tsn';
   name_fr: 'tswana';
   name_en: 'Tswana';
  ),
  (
   code: 'ts';
   biblio_code: 'tso';
   name_fr: 'tsonga';
   name_en: 'Tsonga';
  ),
  (
   code: 'tk';
   biblio_code: 'tuk';
   name_fr: 'turkm'#232'ne';
   name_en: 'Turkmen';
  ),
  (
   code: '';
   biblio_code: 'tum';
   name_fr: 'tumbuka';
   name_en: 'Tumbuka';
  ),
  (
   code: '';
   biblio_code: 'tup';
   name_fr: 'tupi, langues';
   name_en: 'Tupi languages';
  ),
  (
   code: 'tr';
   biblio_code: 'tur';
   name_fr: 'turc';
   name_en: 'Turkish';
  ),
  (
   code: '';
   biblio_code: 'tut';
   name_fr: 'alta'#239'ques, langues';
   name_en: 'Altaic languages';
  ),
  (
   code: '';
   biblio_code: 'tvl';
   name_fr: 'tuvalu';
   name_en: 'Tuvalu';
  ),
  (
   code: 'tw';
   biblio_code: 'twi';
   name_fr: 'twi';
   name_en: 'Twi';
  ),
  (
   code: '';
   biblio_code: 'tyv';
   name_fr: 'touva';
   name_en: 'Tuvinian';
  ),
  (
   code: '';
   biblio_code: 'udm';
   name_fr: 'oudmourte';
   name_en: 'Udmurt';
  ),
  (
   code: '';
   biblio_code: 'uga';
   name_fr: 'ougaritique';
   name_en: 'Ugaritic';
  ),
  (
   code: 'ug';
   biblio_code: 'uig';
   name_fr: 'ou'#239'gour';
   name_en: 'Uighur; Uyghur';
  ),
  (
   code: 'uk';
   biblio_code: 'ukr';
   name_fr: 'ukrainien';
   name_en: 'Ukrainian';
  ),
  (
   code: '';
   biblio_code: 'umb';
   name_fr: 'umbundu';
   name_en: 'Umbundu';
  ),
  (
   code: '';
   biblio_code: 'und';
   name_fr: 'ind'#233'termin'#233'e';
   name_en: 'Undetermined';
  ),
  (
   code: 'ur';
   biblio_code: 'urd';
   name_fr: 'ourdou';
   name_en: 'Urdu';
  ),
  (
   code: 'uz';
   biblio_code: 'uzb';
   name_fr: 'ouszbek';
   name_en: 'Uzbek';
  ),
  (
   code: '';
   biblio_code: 'vai';
   name_fr: 'va'#239'';
   name_en: 'Vai';
  ),
  (
   code: 've';
   biblio_code: 'ven';
   name_fr: 'venda';
   name_en: 'Venda';
  ),
  (
   code: 'vi';
   biblio_code: 'vie';
   name_fr: 'vietnamien';
   name_en: 'Vietnamese';
  ),
  (
   code: 'vo';
   biblio_code: 'vol';
   name_fr: 'volap'#252'k';
   name_en: 'Volap'#252'k';
  ),
  (
   code: '';
   biblio_code: 'vot';
   name_fr: 'vote';
   name_en: 'Votic';
  ),
  (
   code: '';
   biblio_code: 'wak';
   name_fr: 'wakashanes, langues';
   name_en: 'Wakashan languages';
  ),
  (
   code: '';
   biblio_code: 'wal';
   name_fr: 'wolaitta; wolaytta';
   name_en: 'Wolaitta; Wolaytta';
  ),
  (
   code: '';
   biblio_code: 'war';
   name_fr: 'waray';
   name_en: 'Waray';
  ),
  (
   code: '';
   biblio_code: 'was';
   name_fr: 'washo';
   name_en: 'Washo';
  ),
  (
   code: 'cy';
   biblio_code: 'wel';
   name_fr: 'gallois';
   name_en: 'Welsh';
  ),
  (
   code: '';
   biblio_code: 'wen';
   name_fr: 'sorabes, langues';
   name_en: 'Sorbian languages';
  ),
  (
   code: 'wa';
   biblio_code: 'wln';
   name_fr: 'wallon';
   name_en: 'Walloon';
  ),
  (
   code: 'wo';
   biblio_code: 'wol';
   name_fr: 'wolof';
   name_en: 'Wolof';
  ),
  (
   code: '';
   biblio_code: 'xal';
   name_fr: 'kalmouk; o'#239'rat';
   name_en: 'Kalmyk; Oirat';
  ),
  (
   code: 'xh';
   biblio_code: 'xho';
   name_fr: 'xhosa';
   name_en: 'Xhosa';
  ),
  (
   code: '';
   biblio_code: 'yao';
   name_fr: 'yao';
   name_en: 'Yao';
  ),
  (
   code: '';
   biblio_code: 'yap';
   name_fr: 'yapois';
   name_en: 'Yapese';
  ),
  (
   code: 'yi';
   biblio_code: 'yid';
   name_fr: 'yiddish';
   name_en: 'Yiddish';
  ),
  (
   code: 'yo';
   biblio_code: 'yor';
   name_fr: 'yoruba';
   name_en: 'Yoruba';
  ),
  (
   code: '';
   biblio_code: 'ypk';
   name_fr: 'yupik, langues';
   name_en: 'Yupik languages';
  ),
  (
   code: '';
   biblio_code: 'zap';
   name_fr: 'zapot'#232'que';
   name_en: 'Zapotec';
  ),
  (
   code: '';
   biblio_code: 'zbl';
   name_fr: 'symboles Bliss; Bliss';
   name_en: 'Blissymbols; Blissymbolics; Bliss';
  ),
  (
   code: '';
   biblio_code: 'zen';
   name_fr: 'zenaga';
   name_en: 'Zenaga';
  ),
  (
   code: 'za';
   biblio_code: 'zha';
   name_fr: 'zhuang; chuang';
   name_en: 'Zhuang; Chuang';
  ),
  (
   code: '';
   biblio_code: 'znd';
   name_fr: 'zand'#233', langues';
   name_en: 'Zande languages';
  ),
  (
   code: 'zu';
   biblio_code: 'zul';
   name_fr: 'zoulou';
   name_en: 'Zulu';
  ),
  (
   code: '';
   biblio_code: 'zun';
   name_fr: 'zuni';
   name_en: 'Zuni';
  ),
  (
   code: '';
   biblio_code: 'zxx';
   name_fr: 'pas de contenu linguistique; non applicable';
   name_en: 'No linguistic content; Not applicable';
  ),
  (
   code: '';
   biblio_code: 'zza';
   name_fr: 'zaza; dimili; dimli; kirdki; kirmanjki; zazaki';
   name_en: 'Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki';
  )
);
{$else}
procedure langcodesproc; 
{$endif}

implementation

{$ifdef TP}
procedure langcodesproc; external; {$L iso639.obj}
{$endif}

end.
