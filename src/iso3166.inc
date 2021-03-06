const
  MAX_ENTRIES =240;
type
  TCountryInfo = record
    name_fr: string[44];
    name_en: string[44];
    code: string[2];
    active: boolean;
  end;


const
  CountryInfo: array[1..MAX_ENTRIES] of TCountryInfo = (
  (
   name_fr: 'AFGHANISTAN';
   name_en: 'AFGHANISTAN';
   code: 'AF';
   active: true
  ),
  (
   name_fr: '�LAND, �LES D''''';
   name_en: '�LAND ISLANDS';
   code: 'AX';
   active: true
  ),
  (
   name_fr: 'ALBANIE';
   name_en: 'ALBANIA';
   code: 'AL';
   active: true
  ),
  (
   name_fr: 'ALG�RIE';
   name_en: 'ALGERIA';
   code: 'DZ';
   active: true
  ),
  (
   name_fr: 'SAMOA AM�RICAINES';
   name_en: 'AMERICAN SAMOA';
   code: 'AS';
   active: true
  ),
  (
   name_fr: 'ANDORRE';
   name_en: 'ANDORRA';
   code: 'AD';
   active: true
  ),
  (
   name_fr: 'ANGOLA';
   name_en: 'ANGOLA';
   code: 'AO';
   active: true
  ),
  (
   name_fr: 'ANGUILLA';
   name_en: 'ANGUILLA';
   code: 'AI';
   active: true
  ),
  (
   name_fr: 'ANTARCTIQUE';
   name_en: 'ANTARCTICA';
   code: 'AQ';
   active: true
  ),
  (
   name_fr: 'ANTIGUA-ET-BARBUDA';
   name_en: 'ANTIGUA AND BARBUDA';
   code: 'AG';
   active: true
  ),
  (
   name_fr: 'ARGENTINE';
   name_en: 'ARGENTINA';
   code: 'AR';
   active: true
  ),
  (
   name_fr: 'ARM�NIE';
   name_en: 'ARMENIA';
   code: 'AM';
   active: true
  ),
  (
   name_fr: 'ARUBA';
   name_en: 'ARUBA';
   code: 'AW';
   active: true
  ),
  (
   name_fr: 'AUSTRALIE';
   name_en: 'AUSTRALIA';
   code: 'AU';
   active: true
  ),
  (
   name_fr: 'AUTRICHE';
   name_en: 'AUSTRIA';
   code: 'AT';
   active: true
  ),
  (
   name_fr: 'AZERBA�DJAN';
   name_en: 'AZERBAIJAN';
   code: 'AZ';
   active: true
  ),
  (
   name_fr: 'BAHAMAS';
   name_en: 'BAHAMAS';
   code: 'BS';
   active: true
  ),
  (
   name_fr: 'BAHRE�N';
   name_en: 'BAHRAIN';
   code: 'BH';
   active: true
  ),
  (
   name_fr: 'BANGLADESH';
   name_en: 'BANGLADESH';
   code: 'BD';
   active: true
  ),
  (
   name_fr: 'BARBADE';
   name_en: 'BARBADOS';
   code: 'BB';
   active: true
  ),
  (
   name_fr: 'B�LARUS';
   name_en: 'BELARUS';
   code: 'BY';
   active: true
  ),
  (
   name_fr: 'BELGIQUE';
   name_en: 'BELGIUM';
   code: 'BE';
   active: true
  ),
  (
   name_fr: 'BELIZE';
   name_en: 'BELIZE';
   code: 'BZ';
   active: true
  ),
  (
   name_fr: 'B�NIN';
   name_en: 'BENIN';
   code: 'BJ';
   active: true
  ),
  (
   name_fr: 'BERMUDES';
   name_en: 'BERMUDA';
   code: 'BM';
   active: true
  ),
  (
   name_fr: 'BHOUTAN';
   name_en: 'BHUTAN';
   code: 'BT';
   active: true
  ),
  (
   name_fr: 'BOLIVIE';
   name_en: 'BOLIVIA';
   code: 'BO';
   active: true
  ),
  (
   name_fr: 'BOSNIE-HERZ�GOVINE';
   name_en: 'BOSNIA AND HERZEGOVINA';
   code: 'BA';
   active: true
  ),
  (
   name_fr: 'BOTSWANA';
   name_en: 'BOTSWANA';
   code: 'BW';
   active: true
  ),
  (
   name_fr: 'BOUVET, �LE';
   name_en: 'BOUVET ISLAND';
   code: 'BV';
   active: true
  ),
  (
   name_fr: 'BR�SIL';
   name_en: 'BRAZIL';
   code: 'BR';
   active: true
  ),
  (
   name_fr: 'OC�AN INDIEN, TERRITOIRE BRITANNIQUE DE L''''';
   name_en: 'BRITISH INDIAN OCEAN TERRITORY';
   code: 'IO';
   active: true
  ),
  (
   name_fr: 'BRUN�I DARUSSALAM';
   name_en: 'BRUNEI DARUSSALAM';
   code: 'BN';
   active: true
  ),
  (
   name_fr: 'BULGARIE';
   name_en: 'BULGARIA';
   code: 'BG';
   active: true
  ),
  (
   name_fr: 'BURKINA FASO';
   name_en: 'BURKINA FASO';
   code: 'BF';
   active: true
  ),
  (
   name_fr: 'BURUNDI';
   name_en: 'BURUNDI';
   code: 'BI';
   active: true
  ),
  (
   name_fr: 'CAMBODGE';
   name_en: 'CAMBODIA';
   code: 'KH';
   active: true
  ),
  (
   name_fr: 'CAMEROUN';
   name_en: 'CAMEROON';
   code: 'CM';
   active: true
  ),
  (
   name_fr: 'CANADA';
   name_en: 'CANADA';
   code: 'CA';
   active: true
  ),
  (
   name_fr: 'CAP-VERT';
   name_en: 'CAPE VERDE';
   code: 'CV';
   active: true
  ),
  (
   name_fr: 'CA�MANES, �LES';
   name_en: 'CAYMAN ISLANDS';
   code: 'KY';
   active: true
  ),
  (
   name_fr: 'CENTRAFRICAINE, R�PUBLIQUE';
   name_en: 'CENTRAL AFRICAN REPUBLIC';
   code: 'CF';
   active: true
  ),
  (
   name_fr: 'TCHAD';
   name_en: 'CHAD';
   code: 'TD';
   active: true
  ),
  (
   name_fr: 'CHILI';
   name_en: 'CHILE';
   code: 'CL';
   active: true
  ),
  (
   name_fr: 'CHINE';
   name_en: 'CHINA';
   code: 'CN';
   active: true
  ),
  (
   name_fr: 'CHRISTMAS, �LE';
   name_en: 'CHRISTMAS ISLAND';
   code: 'CX';
   active: true
  ),
  (
   name_fr: 'COCOS (KEELING), �LES';
   name_en: 'COCOS (KEELING) ISLANDS';
   code: 'CC';
   active: true
  ),
  (
   name_fr: 'COLOMBIE';
   name_en: 'COLOMBIA';
   code: 'CO';
   active: true
  ),
  (
   name_fr: 'COMORES';
   name_en: 'COMOROS';
   code: 'KM';
   active: true
  ),
  (
   name_fr: 'CONGO';
   name_en: 'CONGO';
   code: 'CG';
   active: true
  ),
  (
   name_fr: 'CONGO, LA R�PUBLIQUE D�MOCRATIQUE DU';
   name_en: 'CONGO, THE DEMOCRATIC REPUBLIC OF THE';
   code: 'CD';
   active: true
  ),
  (
   name_fr: 'COOK, �LES';
   name_en: 'COOK ISLANDS';
   code: 'CK';
   active: true
  ),
  (
   name_fr: 'COSTA RICA';
   name_en: 'COSTA RICA';
   code: 'CR';
   active: true
  ),
  (
   name_fr: 'C�TE D''''IVOIRE';
   name_en: 'COTE D''''IVOIRE';
   code: 'CI';
   active: true
  ),
  (
   name_fr: 'CROATIE';
   name_en: 'CROATIA';
   code: 'HR';
   active: true
  ),
  (
   name_fr: 'CUBA';
   name_en: 'CUBA';
   code: 'CU';
   active: true
  ),
  (
   name_fr: 'CHYPRE';
   name_en: 'CYPRUS';
   code: 'CY';
   active: true
  ),
  (
   name_fr: 'TCH�QUE, R�PUBLIQUE';
   name_en: 'CZECH REPUBLIC';
   code: 'CZ';
   active: true
  ),
  (
   name_fr: 'DANEMARK';
   name_en: 'DENMARK';
   code: 'DK';
   active: true
  ),
  (
   name_fr: 'DJIBOUTI';
   name_en: 'DJIBOUTI';
   code: 'DJ';
   active: true
  ),
  (
   name_fr: 'DOMINIQUE';
   name_en: 'DOMINICA';
   code: 'DM';
   active: true
  ),
  (
   name_fr: 'DOMINICAINE, R�PUBLIQUE';
   name_en: 'DOMINICAN REPUBLIC';
   code: 'DO';
   active: true
  ),
  (
   name_fr: '�QUATEUR';
   name_en: 'ECUADOR';
   code: 'EC';
   active: true
  ),
  (
   name_fr: '�GYPTE';
   name_en: 'EGYPT';
   code: 'EG';
   active: true
  ),
  (
   name_fr: 'EL SALVADOR';
   name_en: 'EL SALVADOR';
   code: 'SV';
   active: true
  ),
  (
   name_fr: 'GUIN�E �QUATORIALE';
   name_en: 'EQUATORIAL GUINEA';
   code: 'GQ';
   active: true
  ),
  (
   name_fr: '�RYTHR�E';
   name_en: 'ERITREA';
   code: 'ER';
   active: true
  ),
  (
   name_fr: 'ESTONIE';
   name_en: 'ESTONIA';
   code: 'EE';
   active: true
  ),
  (
   name_fr: '�THIOPIE';
   name_en: 'ETHIOPIA';
   code: 'ET';
   active: true
  ),
  (
   name_fr: 'FALKLAND, �LES (MALVINAS)';
   name_en: 'FALKLAND ISLANDS (MALVINAS)';
   code: 'FK';
   active: true
  ),
  (
   name_fr: 'F�RO�, �LES';
   name_en: 'FAROE ISLANDS';
   code: 'FO';
   active: true
  ),
  (
   name_fr: 'FIDJI';
   name_en: 'FIJI';
   code: 'FJ';
   active: true
  ),
  (
   name_fr: 'FINLANDE';
   name_en: 'FINLAND';
   code: 'FI';
   active: true
  ),
  (
   name_fr: 'FRANCE';
   name_en: 'FRANCE';
   code: 'FR';
   active: true
  ),
  (
   name_fr: 'GUYANE FRAN�AISE';
   name_en: 'FRENCH GUIANA';
   code: 'GF';
   active: true
  ),
  (
   name_fr: 'POLYN�SIE FRAN�AISE';
   name_en: 'FRENCH POLYNESIA';
   code: 'PF';
   active: true
  ),
  (
   name_fr: 'TERRES AUSTRALES FRAN�AISES';
   name_en: 'FRENCH SOUTHERN TERRITORIES';
   code: 'TF';
   active: true
  ),
  (
   name_fr: 'GABON';
   name_en: 'GABON';
   code: 'GA';
   active: true
  ),
  (
   name_fr: 'GAMBIE';
   name_en: 'GAMBIA';
   code: 'GM';
   active: true
  ),
  (
   name_fr: 'G�ORGIE';
   name_en: 'GEORGIA';
   code: 'GE';
   active: true
  ),
  (
   name_fr: 'ALLEMAGNE';
   name_en: 'GERMANY';
   code: 'DE';
   active: true
  ),
  (
   name_fr: 'GHANA';
   name_en: 'GHANA';
   code: 'GH';
   active: true
  ),
  (
   name_fr: 'GIBRALTAR';
   name_en: 'GIBRALTAR';
   code: 'GI';
   active: true
  ),
  (
   name_fr: 'GR�CE';
   name_en: 'GREECE';
   code: 'GR';
   active: true
  ),
  (
   name_fr: 'GROENLAND';
   name_en: 'GREENLAND';
   code: 'GL';
   active: true
  ),
  (
   name_fr: 'GRENADE';
   name_en: 'GRENADA';
   code: 'GD';
   active: true
  ),
  (
   name_fr: 'GUADELOUPE';
   name_en: 'GUADELOUPE';
   code: 'GP';
   active: true
  ),
  (
   name_fr: 'GUAM';
   name_en: 'GUAM';
   code: 'GU';
   active: true
  ),
  (
   name_fr: 'GUATEMALA';
   name_en: 'GUATEMALA';
   code: 'GT';
   active: true
  ),
  (
   name_fr: 'GUIN�E';
   name_en: 'GUINEA';
   code: 'GN';
   active: true
  ),
  (
   name_fr: 'GUIN�E-BISSAU';
   name_en: 'GUINEA-BISSAU';
   code: 'GW';
   active: true
  ),
  (
   name_fr: 'GUYANA';
   name_en: 'GUYANA';
   code: 'GY';
   active: true
  ),
  (
   name_fr: 'HA�TI';
   name_en: 'HAITI';
   code: 'HT';
   active: true
  ),
  (
   name_fr: 'HEARD, �LE ET MCDONALD, �LES';
   name_en: 'HEARD ISLAND AND MCDONALD ISLANDS';
   code: 'HM';
   active: true
  ),
  (
   name_fr: 'SAINT-SI�GE (�TAT DE LA CIT� DU VATICAN)';
   name_en: 'HOLY SEE (VATICAN CITY STATE)';
   code: 'VA';
   active: true
  ),
  (
   name_fr: 'HONDURAS';
   name_en: 'HONDURAS';
   code: 'HN';
   active: true
  ),
  (
   name_fr: 'HONG-KONG';
   name_en: 'HONG KONG';
   code: 'HK';
   active: true
  ),
  (
   name_fr: 'HONGRIE';
   name_en: 'HUNGARY';
   code: 'HU';
   active: true
  ),
  (
   name_fr: 'ISLANDE';
   name_en: 'ICELAND';
   code: 'IS';
   active: true
  ),
  (
   name_fr: 'INDE';
   name_en: 'INDIA';
   code: 'IN';
   active: true
  ),
  (
   name_fr: 'INDON�SIE';
   name_en: 'INDONESIA';
   code: 'ID';
   active: true
  ),
  (
   name_fr: 'IRAN, R�PUBLIQUE ISLAMIQUE D''''';
   name_en: 'IRAN, ISLAMIC REPUBLIC OF';
   code: 'IR';
   active: true
  ),
  (
   name_fr: 'IRAQ';
   name_en: 'IRAQ';
   code: 'IQ';
   active: true
  ),
  (
   name_fr: 'IRLANDE';
   name_en: 'IRELAND';
   code: 'IE';
   active: true
  ),
  (
   name_fr: 'ISRA�L';
   name_en: 'ISRAEL';
   code: 'IL';
   active: true
  ),
  (
   name_fr: 'ITALIE';
   name_en: 'ITALY';
   code: 'IT';
   active: true
  ),
  (
   name_fr: 'JAMA�QUE';
   name_en: 'JAMAICA';
   code: 'JM';
   active: true
  ),
  (
   name_fr: 'JAPON';
   name_en: 'JAPAN';
   code: 'JP';
   active: true
  ),
  (
   name_fr: 'JORDANIE';
   name_en: 'JORDAN';
   code: 'JO';
   active: true
  ),
  (
   name_fr: 'KAZAKHSTAN';
   name_en: 'KAZAKHSTAN';
   code: 'KZ';
   active: true
  ),
  (
   name_fr: 'KENYA';
   name_en: 'KENYA';
   code: 'KE';
   active: true
  ),
  (
   name_fr: 'KIRIBATI';
   name_en: 'KIRIBATI';
   code: 'KI';
   active: true
  ),
  (
   name_fr: 'COR�E, R�PUBLIQUE POPULAIRE D�MOCRATIQUE DE';
   name_en: 'KOREA, DEMOCRATIC PEOPLE''''S REPUBLIC OF';
   code: 'KP';
   active: true
  ),
  (
   name_fr: 'COR�E, R�PUBLIQUE DE';
   name_en: 'KOREA, REPUBLIC OF';
   code: 'KR';
   active: true
  ),
  (
   name_fr: 'KOWE�T';
   name_en: 'KUWAIT';
   code: 'KW';
   active: true
  ),
  (
   name_fr: 'KIRGHIZISTAN';
   name_en: 'KYRGYZSTAN';
   code: 'KG';
   active: true
  ),
  (
   name_fr: 'LAO, R�PUBLIQUE D�MOCRATIQUE POPULAIRE';
   name_en: 'LAO PEOPLE''''S DEMOCRATIC REPUBLIC';
   code: 'LA';
   active: true
  ),
  (
   name_fr: 'LETTONIE';
   name_en: 'LATVIA';
   code: 'LV';
   active: true
  ),
  (
   name_fr: 'LIBAN';
   name_en: 'LEBANON';
   code: 'LB';
   active: true
  ),
  (
   name_fr: 'LESOTHO';
   name_en: 'LESOTHO';
   code: 'LS';
   active: true
  ),
  (
   name_fr: 'LIB�RIA';
   name_en: 'LIBERIA';
   code: 'LR';
   active: true
  ),
  (
   name_fr: 'LIBYENNE, JAMAHIRIYA ARABE';
   name_en: 'LIBYAN ARAB JAMAHIRIYA';
   code: 'LY';
   active: true
  ),
  (
   name_fr: 'LIECHTENSTEIN';
   name_en: 'LIECHTENSTEIN';
   code: 'LI';
   active: true
  ),
  (
   name_fr: 'LITUANIE';
   name_en: 'LITHUANIA';
   code: 'LT';
   active: true
  ),
  (
   name_fr: 'LUXEMBOURG';
   name_en: 'LUXEMBOURG';
   code: 'LU';
   active: true
  ),
  (
   name_fr: 'MACAO';
   name_en: 'MACAO';
   code: 'MO';
   active: true
  ),
  (
   name_fr: 'MAC�DOINE, L''''EX-R�PUBLIQUE YOUGOSLAVE DE';
   name_en: 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF';
   code: 'MK';
   active: true
  ),
  (
   name_fr: 'MADAGASCAR';
   name_en: 'MADAGASCAR';
   code: 'MG';
   active: true
  ),
  (
   name_fr: 'MALAWI';
   name_en: 'MALAWI';
   code: 'MW';
   active: true
  ),
  (
   name_fr: 'MALAISIE';
   name_en: 'MALAYSIA';
   code: 'MY';
   active: true
  ),
  (
   name_fr: 'MALDIVES';
   name_en: 'MALDIVES';
   code: 'MV';
   active: true
  ),
  (
   name_fr: 'MALI';
   name_en: 'MALI';
   code: 'ML';
   active: true
  ),
  (
   name_fr: 'MALTE';
   name_en: 'MALTA';
   code: 'MT';
   active: true
  ),
  (
   name_fr: 'MARSHALL, �LES';
   name_en: 'MARSHALL ISLANDS';
   code: 'MH';
   active: true
  ),
  (
   name_fr: 'MARTINIQUE';
   name_en: 'MARTINIQUE';
   code: 'MQ';
   active: true
  ),
  (
   name_fr: 'MAURITANIE';
   name_en: 'MAURITANIA';
   code: 'MR';
   active: true
  ),
  (
   name_fr: 'MAURICE';
   name_en: 'MAURITIUS';
   code: 'MU';
   active: true
  ),
  (
   name_fr: 'MAYOTTE';
   name_en: 'MAYOTTE';
   code: 'YT';
   active: true
  ),
  (
   name_fr: 'MEXIQUE';
   name_en: 'MEXICO';
   code: 'MX';
   active: true
  ),
  (
   name_fr: 'MICRON�SIE, �TATS F�D�R�S DE';
   name_en: 'MICRONESIA, FEDERATED STATES OF';
   code: 'FM';
   active: true
  ),
  (
   name_fr: 'MOLDOVA, R�PUBLIQUE DE';
   name_en: 'MOLDOVA, REPUBLIC OF';
   code: 'MD';
   active: true
  ),
  (
   name_fr: 'MONACO';
   name_en: 'MONACO';
   code: 'MC';
   active: true
  ),
  (
   name_fr: 'MONGOLIE';
   name_en: 'MONGOLIA';
   code: 'MN';
   active: true
  ),
  (
   name_fr: 'MONTSERRAT';
   name_en: 'MONTSERRAT';
   code: 'MS';
   active: true
  ),
  (
   name_fr: 'MAROC';
   name_en: 'MOROCCO';
   code: 'MA';
   active: true
  ),
  (
   name_fr: 'MOZAMBIQUE';
   name_en: 'MOZAMBIQUE';
   code: 'MZ';
   active: true
  ),
  (
   name_fr: 'MYANMAR';
   name_en: 'MYANMAR';
   code: 'MM';
   active: true
  ),
  (
   name_fr: 'NAMIBIE';
   name_en: 'NAMIBIA';
   code: 'NA';
   active: true
  ),
  (
   name_fr: 'NAURU';
   name_en: 'NAURU';
   code: 'NR';
   active: true
  ),
  (
   name_fr: 'N�PAL';
   name_en: 'NEPAL';
   code: 'NP';
   active: true
  ),
  (
   name_fr: 'PAYS-BAS';
   name_en: 'NETHERLANDS';
   code: 'NL';
   active: true
  ),
  (
   name_fr: 'ANTILLES N�ERLANDAISES';
   name_en: 'NETHERLANDS ANTILLES';
   code: 'AN';
   active: true
  ),
  (
   name_fr: 'NOUVELLE-CAL�DONIE';
   name_en: 'NEW CALEDONIA';
   code: 'NC';
   active: true
  ),
  (
   name_fr: 'NOUVELLE-Z�LANDE';
   name_en: 'NEW ZEALAND';
   code: 'NZ';
   active: true
  ),
  (
   name_fr: 'NICARAGUA';
   name_en: 'NICARAGUA';
   code: 'NI';
   active: true
  ),
  (
   name_fr: 'NIGER';
   name_en: 'NIGER';
   code: 'NE';
   active: true
  ),
  (
   name_fr: 'NIG�RIA';
   name_en: 'NIGERIA';
   code: 'NG';
   active: true
  ),
  (
   name_fr: 'NIU�';
   name_en: 'NIUE';
   code: 'NU';
   active: true
  ),
  (
   name_fr: 'NORFOLK, �LE';
   name_en: 'NORFOLK ISLAND';
   code: 'NF';
   active: true
  ),
  (
   name_fr: 'MARIANNES DU NORD, �LES';
   name_en: 'NORTHERN MARIANA ISLANDS';
   code: 'MP';
   active: true
  ),
  (
   name_fr: 'NORV�GE';
   name_en: 'NORWAY';
   code: 'NO';
   active: true
  ),
  (
   name_fr: 'OMAN';
   name_en: 'OMAN';
   code: 'OM';
   active: true
  ),
  (
   name_fr: 'PAKISTAN';
   name_en: 'PAKISTAN';
   code: 'PK';
   active: true
  ),
  (
   name_fr: 'PALAOS';
   name_en: 'PALAU';
   code: 'PW';
   active: true
  ),
  (
   name_fr: 'PALESTINIEN OCCUP�, TERRITOIRE';
   name_en: 'PALESTINIAN TERRITORY, OCCUPIED';
   code: 'PS';
   active: true
  ),
  (
   name_fr: 'PANAMA';
   name_en: 'PANAMA';
   code: 'PA';
   active: true
  ),
  (
   name_fr: 'PAPOUASIE-NOUVELLE-GUIN�E';
   name_en: 'PAPUA NEW GUINEA';
   code: 'PG';
   active: true
  ),
  (
   name_fr: 'PARAGUAY';
   name_en: 'PARAGUAY';
   code: 'PY';
   active: true
  ),
  (
   name_fr: 'P�ROU';
   name_en: 'PERU';
   code: 'PE';
   active: true
  ),
  (
   name_fr: 'PHILIPPINES';
   name_en: 'PHILIPPINES';
   code: 'PH';
   active: true
  ),
  (
   name_fr: 'PITCAIRN';
   name_en: 'PITCAIRN';
   code: 'PN';
   active: true
  ),
  (
   name_fr: 'POLOGNE';
   name_en: 'POLAND';
   code: 'PL';
   active: true
  ),
  (
   name_fr: 'PORTUGAL';
   name_en: 'PORTUGAL';
   code: 'PT';
   active: true
  ),
  (
   name_fr: 'PORTO RICO';
   name_en: 'PUERTO RICO';
   code: 'PR';
   active: true
  ),
  (
   name_fr: 'QATAR';
   name_en: 'QATAR';
   code: 'QA';
   active: true
  ),
  (
   name_fr: 'R�UNION';
   name_en: 'REUNION';
   code: 'RE';
   active: true
  ),
  (
   name_fr: 'ROUMANIE';
   name_en: 'ROMANIA';
   code: 'RO';
   active: true
  ),
  (
   name_fr: 'RUSSIE, F�D�RATION DE';
   name_en: 'RUSSIAN FEDERATION';
   code: 'RU';
   active: true
  ),
  (
   name_fr: 'RWANDA';
   name_en: 'RWANDA';
   code: 'RW';
   active: true
  ),
  (
   name_fr: 'SAINTE-H�L�NE';
   name_en: 'SAINT HELENA';
   code: 'SH';
   active: true
  ),
  (
   name_fr: 'SAINT-KITTS-ET-NEVIS';
   name_en: 'SAINT KITTS AND NEVIS';
   code: 'KN';
   active: true
  ),
  (
   name_fr: 'SAINTE-LUCIE';
   name_en: 'SAINT LUCIA';
   code: 'LC';
   active: true
  ),
  (
   name_fr: 'SAINT-PIERRE-ET-MIQUELON';
   name_en: 'SAINT PIERRE AND MIQUELON';
   code: 'PM';
   active: true
  ),
  (
   name_fr: 'SAINT-VINCENT-ET-LES GRENADINES';
   name_en: 'SAINT VINCENT AND THE GRENADINES';
   code: 'VC';
   active: true
  ),
  (
   name_fr: 'SAMOA';
   name_en: 'SAMOA';
   code: 'WS';
   active: true
  ),
  (
   name_fr: 'SAINT-MARIN';
   name_en: 'SAN MARINO';
   code: 'SM';
   active: true
  ),
  (
   name_fr: 'SAO TOM�-ET-PRINCIPE';
   name_en: 'SAO TOME AND PRINCIPE';
   code: 'ST';
   active: true
  ),
  (
   name_fr: 'ARABIE SAOUDITE';
   name_en: 'SAUDI ARABIA';
   code: 'SA';
   active: true
  ),
  (
   name_fr: 'S�N�GAL';
   name_en: 'SENEGAL';
   code: 'SN';
   active: true
  ),
  (
   name_fr: 'SERBIE-ET-MONT�N�GRO';
   name_en: 'SERBIA AND MONTENEGRO';
   code: 'CS';
   active: true
  ),
  (
   name_fr: 'SEYCHELLES';
   name_en: 'SEYCHELLES';
   code: 'SC';
   active: true
  ),
  (
   name_fr: 'SIERRA LEONE';
   name_en: 'SIERRA LEONE';
   code: 'SL';
   active: true
  ),
  (
   name_fr: 'SINGAPOUR';
   name_en: 'SINGAPORE';
   code: 'SG';
   active: true
  ),
  (
   name_fr: 'SLOVAQUIE';
   name_en: 'SLOVAKIA';
   code: 'SK';
   active: true
  ),
  (
   name_fr: 'SLOV�NIE';
   name_en: 'SLOVENIA';
   code: 'SI';
   active: true
  ),
  (
   name_fr: 'SALOMON, �LES';
   name_en: 'SOLOMON ISLANDS';
   code: 'SB';
   active: true
  ),
  (
   name_fr: 'SOMALIE';
   name_en: 'SOMALIA';
   code: 'SO';
   active: true
  ),
  (
   name_fr: 'AFRIQUE DU SUD';
   name_en: 'SOUTH AFRICA';
   code: 'ZA';
   active: true
  ),
  (
   name_fr: 'G�ORGIE DU SUD ET LES �LES SANDWICH DU SUD';
   name_en: 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS';
   code: 'GS';
   active: true
  ),
  (
   name_fr: 'ESPAGNE';
   name_en: 'SPAIN';
   code: 'ES';
   active: true
  ),
  (
   name_fr: 'SRI LANKA';
   name_en: 'SRI LANKA';
   code: 'LK';
   active: true
  ),
  (
   name_fr: 'SOUDAN';
   name_en: 'SUDAN';
   code: 'SD';
   active: true
  ),
  (
   name_fr: 'SURINAME';
   name_en: 'SURINAME';
   code: 'SR';
   active: true
  ),
  (
   name_fr: 'SVALBARD ET �LE JAN MAYEN';
   name_en: 'SVALBARD AND JAN MAYEN';
   code: 'SJ';
   active: true
  ),
  (
   name_fr: 'SWAZILAND';
   name_en: 'SWAZILAND';
   code: 'SZ';
   active: true
  ),
  (
   name_fr: 'SU�DE';
   name_en: 'SWEDEN';
   code: 'SE';
   active: true
  ),
  (
   name_fr: 'SUISSE';
   name_en: 'SWITZERLAND';
   code: 'CH';
   active: true
  ),
  (
   name_fr: 'SYRIENNE, R�PUBLIQUE ARABE';
   name_en: 'SYRIAN ARAB REPUBLIC';
   code: 'SY';
   active: true
  ),
  (
   name_fr: 'TA�WAN, PROVINCE DE CHINE';
   name_en: 'TAIWAN, PROVINCE OF CHINA';
   code: 'TW';
   active: true
  ),
  (
   name_fr: 'TADJIKISTAN';
   name_en: 'TAJIKISTAN';
   code: 'TJ';
   active: true
  ),
  (
   name_fr: 'TANZANIE, R�PUBLIQUE-UNIE DE';
   name_en: 'TANZANIA, UNITED REPUBLIC OF';
   code: 'TZ';
   active: true
  ),
  (
   name_fr: 'THA�LANDE';
   name_en: 'THAILAND';
   code: 'TH';
   active: true
  ),
  (
   name_fr: 'TIMOR-LESTE';
   name_en: 'TIMOR-LESTE';
   code: 'TL';
   active: true
  ),
  (
   name_fr: 'TOGO';
   name_en: 'TOGO';
   code: 'TG';
   active: true
  ),
  (
   name_fr: 'TOKELAU';
   name_en: 'TOKELAU';
   code: 'TK';
   active: true
  ),
  (
   name_fr: 'TONGA';
   name_en: 'TONGA';
   code: 'TO';
   active: true
  ),
  (
   name_fr: 'TRINIT�-ET-TOBAGO';
   name_en: 'TRINIDAD AND TOBAGO';
   code: 'TT';
   active: true
  ),
  (
   name_fr: 'TUNISIE';
   name_en: 'TUNISIA';
   code: 'TN';
   active: true
  ),
  (
   name_fr: 'TURQUIE';
   name_en: 'TURKEY';
   code: 'TR';
   active: true
  ),
  (
   name_fr: 'TURKM�NISTAN';
   name_en: 'TURKMENISTAN';
   code: 'TM';
   active: true
  ),
  (
   name_fr: 'TURKS ET CA�QUES, �LES';
   name_en: 'TURKS AND CAICOS ISLANDS';
   code: 'TC';
   active: true
  ),
  (
   name_fr: 'TUVALU';
   name_en: 'TUVALU';
   code: 'TV';
   active: true
  ),
  (
   name_fr: 'OUGANDA';
   name_en: 'UGANDA';
   code: 'UG';
   active: true
  ),
  (
   name_fr: 'UKRAINE';
   name_en: 'UKRAINE';
   code: 'UA';
   active: true
  ),
  (
   name_fr: '�MIRATS ARABES UNIS';
   name_en: 'UNITED ARAB EMIRATES';
   code: 'AE';
   active: true
  ),
  (
   name_fr: 'ROYAUME-UNI';
   name_en: 'UNITED KINGDOM';
   code: 'GB';
   active: true
  ),
  (
   name_fr: '�TATS-UNIS';
   name_en: 'UNITED STATES';
   code: 'US';
   active: true
  ),
  (
   name_fr: '�LES MINEURES �LOIGN�ES DES �TATS-UNIS';
   name_en: 'UNITED STATES MINOR OUTLYING ISLANDS';
   code: 'UM';
   active: true
  ),
  (
   name_fr: 'URUGUAY';
   name_en: 'URUGUAY';
   code: 'UY';
   active: true
  ),
  (
   name_fr: 'OUZB�KISTAN';
   name_en: 'UZBEKISTAN';
   code: 'UZ';
   active: true
  ),
  (
   name_fr: 'VANUATU';
   name_en: 'VANUATU';
   code: 'VU';
   active: true
  ),
  (
   name_fr: 'VENEZUELA';
   name_en: 'VENEZUELA';
   code: 'VE';
   active: true
  ),
  (
   name_fr: 'VIET NAM';
   name_en: 'VIET NAM';
   code: 'VN';
   active: true
  ),
  (
   name_fr: '�LES VIERGES BRITANNIQUES';
   name_en: 'VIRGIN ISLANDS, BRITISH';
   code: 'VG';
   active: true
  ),
  (
   name_fr: '�LES VIERGES DES �TATS-UNIS';
   name_en: 'VIRGIN ISLANDS, U.S.';
   code: 'VI';
   active: true
  ),
  (
   name_fr: 'WALLIS ET FUTUNA';
   name_en: 'WALLIS AND FUTUNA';
   code: 'WF';
   active: true
  ),
  (
   name_fr: 'SAHARA OCCIDENTAL';
   name_en: 'WESTERN SAHARA';
   code: 'EH';
   active: true
  ),
  (
   name_fr: 'Y�MEN';
   name_en: 'YEMEN';
   code: 'YE';
   active: true
  ),
  (
   name_fr: 'ZAMBIE';
   name_en: 'ZAMBIA';
   code: 'ZM';
   active: true
  ),
  (
   name_fr: 'ZIMBABWE';
   name_en: 'ZIMBABWE';
   code: 'ZW';
   active: true
  )
);
