#!/usr/bin/perl

=pod

=encoding UTF-8

=head1 NAME

google_translate.pl: Translates any arbitrary text from one language to another. 

It also preserves formatting tags (e.g. %1$s, %03c, %d, %e), substitution tags (e.g. {} and []}), 
programming functions (class::method) and HTML tags in the input text in the same order as 
as they were encountered. The results are unpredictable when the translated-to language necessarily
requires a sentence-part rearrangement. You should manually check that the tags are in the correct context.

This uses Google Translate API Version 2.0. Look out for a future version that uses Google Translate API V3.
The translation quality is already very good compared to Version 1.0, but you should always manually 
check the resulting translation to avoid embarassment or offence. 

The output if sent to STDOUT. Here is what you can do with it in, say, the BASH shell:

  ~ $ a=$(./google_translate.pl -q "Hello %s, my name is Jeff, the god of biscuits." -s en -t de 2>/dev/null)
  ~ $ printf "$a\n" Peter
  Hallo Peter, mein Name ist Jeff, der Gott der Kekse.

=head1 SYNOPSIS

If you are an Eddie Izzard fan try this. Information and debug messages go to STDERR, hence the 2>/dev/null redirection:

  ./google_translate.pl -s en -t de -q 'Hello world, my name is Jeff, the god of biscuits.' 2>/dev/null

This returns:

  Hallo Welt, ich heiße Jeff, der Gott der Kekse.

=head1 OPTIONS

C<./google_translate.pl B<-s|--source> I<langauge> B<-t|--target> I<langauge> B<-q|--query> I<'text to be translated'> [-d|--debug] [-m|--man]>

=head2 Mandatory

=over

=item B<-s|--source>

ISO639.1 Language to translate from, see below.

=item B<-t|--target>

ISO639.1 Language to translate to, see below.

=item B<-q|--query>

String to be translated, in inverted commas. Remember to escape embedded embedded inverted commas.

=back

=head2 Optional

=over

=item B<-d|--debug>

Debug mode - displays lots of messages in the error log

=item B<-m|--man>

Help - displays the man page for this script

=head2 Optional Advanced

=item B<-l|--linebreak>

Break output lines according to the input linebreaks. 
By default, multi-line output will be merged into a single line 
with actual two characters '\n' that more-or-less correspond to linebreaks 
in the source text.

=back

=head1 Setting yourself up to use Google Cloud Platform API services

See L<https://cloud.google.com/translate/|https://cloud.google.com/translate/>.

You need to have a Google account. A good start is to get a GMail account. 
Then you need to become a Google Cloud Platform user, which means you need to
provide payment details. For the amount of expected use of the Google Translate 
API, you are unlikely to ever need to pay, but check out the costs as greed 
always eventually wins.

Download and install the Google Cloud Platform SDK. Got to 
L<https://cloud.google.com/translate/docs/quickstart|https://cloud.google.com/translate/docs/quickstart> 
and follow the steps for version 2.0: Set up a Google Cloud Platform project 
if you don't already have one that you can piggy-back off in the GCP console.
Download your private key as a JSON file and keep in a place where it is safe
(a naughty person could run charges up if this falls in the wrong hands)
and will not be deleted, e.g. C<<${HOME}/.gcp/v2/[projectname]-[id].json>>.
Set this environment variable:

  $ export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.gcp/[projectname]-[id].json"

Add this line above to your ~/.bashrc file. Use C<<${HOME}>>, not C<<~>>. 
Windows users, you are all just pathetic. Bedtime! This is not for you, only for grown-ups.
Test it with this command: 

  $ gcloud auth application-default print-access-token

It should return a long key string.

Now try this (C&P code into terminal is recommended here!):

  $ curl -s -X POST -H "Content-Type: application/json" \
      -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
      --data "{
    'q': 'Hello world, my name is Jeff, the god of biscuits.',
    'source': 'en',
    'target': 'de',
    'format': 'text'
  }" "https://translation.googleapis.com/language/translate/v2"

It should output some JSON data that looks like this: 

  {
    "data": {
      "translations": [
        {
          "translatedText": "Hallo Welt, ich heiße Jeff"
        }
      ]
    }
  }

=head1 Supported Languages:

These are the languages supported by Google Translate as of April 2019, with the ISO639.1/2 code to use:

B<Afrikaans> af, B<Albanian> sq, B<Amharic> am, B<Arabic> ar, B<Armenian> hy, B<Azerbaijani> az, B<Basque> eu, 
B<Belarusian> be, B<Bengali> bn, B<Bosnian> bs, B<Bulgarian> bg, B<Catalan> ca, B<Cebuano> ceb (ISO-639-2), 
B<Chinese (Simplified)> zh-CN, B<Chinese (Traditional)> zh-TW, B<Corsican> co, B<Croatian> hr, B<Czech> cs, 
B<Danish> da, B<Dutch> nl, B<English> en, B<Esperanto> eo, B<Estonian> et, B<Finnish> fi, B<French> fr, 
B<Frisian> fy, B<Galician> gl, B<Georgian> ka, B<German> de, B<Greek> el, B<Gujarati> gu, B<Haitian Creole> ht, 
B<Hausa> ha, B<Hawaiian> haw (ISO-639-2), B<Hebrew> he**, B<Hindi> hi, B<Hmong> hmn (ISO-639-2), B<Hungarian> hu, 
B<Icelandic> is, B<Igbo> ig, B<Indonesian> id, B<Irish> ga, B<Italian> it, B<Japanese> ja, B<Javanese> jw, 
B<Kannada> kn, B<Kazakh> kk, B<Khmer> km, B<Korean> ko, B<Kurdish> ku, B<Kyrgyz> ky, B<Lao> lo, B<Latin> la, 
B<Latvian> lv, B<Lithuanian> lt, B<Luxembourgish> lb, B<Macedonian> mk, B<Malagasy> mg, B<Malay> ms, 
B<Malayalam> ml, B<Maltese> mt, B<Maori> mi, B<Marathi> mr, B<Mongolian> mn, B<Myanmar (Burmese)> my, 
B<Nepali> ne, B<Norwegian> no, B<Nyanja (Chichewa)> ny, B<Pashto> ps, B<Persian> fa, B<Polish> pl, 
B<Portuguese> pt, B<Punjabi> pa, B<Romanian> ro, B<Russian> ru, B<Samoan> sm, B<Scots Gaelic> gd, 
B<Serbian> sr, B<Sesotho> st, B<Shona> sn, B<Sindhi> sd, B<Sinhala> si, B<Slovak> sk, B<Slovenian> sl, 
B<Somali> so, B<Spanish> es, B<Sundanese> su, B<Swahili> sw, B<Swedish> sv, B<Tagalog> tl, B<Tajik> tg, 
B<Tamil> ta, B<Telugu> te, B<Thai> th, B<Turkish> tr, B<Ukrainian> uk, B<Urdu> ur, B<Uzbek> uz, B<Vietnamese> vi, 
B<Welsh> cy, B<Xhosa> xh, B<Yiddish> yi, B<Yoruba> yo, B<Zulu> zu

=head2 Notes:

To update the README file, do this:

  pod2markdown google_translate.pl > README.md

=cut

use strict;
use warnings;
use 5.010;
use boolean;
use Getopt::Long qw/:config no_ignore_case/;
use Pod::Usage;
use REST::Client;
use JSON::PP;
use utf8;
use Log::Log4perl qw/:easy/;

# Set up logging
Log::Log4perl->easy_init({  level     => $DEBUG,                            
                            layout    => '[%d][%p][%F{1}-%M-%L] %m%n',
                            utf8      => 1 });

# Options
my ($debug,$man,$source_language,$target_language,$query_string,$linebreak);
# Parse commandline parameters
GetOptions( 'debug|d'               =>\$debug,
            'man|m'                 =>\$man,
            'linebreak|l'           =>\$linebreak,
            'source|s=s'            =>\$source_language,
            'target|t=s'            =>\$target_language,
            'query|q=s'             =>\$query_string,            
          )
 || pod2usage(-exitstatus=>1, -verbose=>1); # show SYNOPSYS and options

if(defined($man)){
  pod2usage(-exitstatus=>1, -verbose=>2); # show complete man page
}

if(!defined($source_language)||!defined($target_language)||!defined($query_string)){
  ERROR "Missing parameters";
  pod2usage(-exitstatus=>1, -verbose=>0);
}

# Defaults:
if(!defined($linebreak)){
  $linebreak=false;
}

# Clean up $query_string
chomp($query_string);
# Escape embedded single speech marks
$query_string =~ s/'/\\'/g;

my $to_be_translated_string="";

# Mark bits in string with [[..]] that should not be translated 
# e.g. " aaaa %s bbbb"  => "aaaa [[%s]] bbbb"
my $tags_marked=$query_string;
$tags_marked =~ s/<[^>]*>/[[$&]]/g;       # HTML Tags
$tags_marked =~ s/\{[^{]*\}/[[$&]]/g;     # Placeholders {}
$tags_marked =~ s/\[[^{]*\]/[[$&]]/g;     # Placeholders []
$tags_marked =~ s/%[^ ]*[sdec]/[[$&]]/g;  # Placeholders %1$s %03c %d %e
$tags_marked =~ s/^.*: ?:[^: ]*/[[$&]]/g; # Function Name: JFTP: :write
$tags_marked =~ s/\"/[[\\"]]/g;           # Embedded inverted commas

my $has_tags=false;
my @tags=(); # Collection of non-translatable tags in query string

if ( $tags_marked ne $query_string ) {
  # There are pieces of non-translatable text here
  $has_tags=true;
  # Get non-translatable string-pieces
  # e.g. from "aaaa [[%s]] bbbb", add "%s" to array
  my $s=$tags_marked;
  $s=~s/\]\][^\]]*$//;  # Remove last translatable texxt
  @tags=split(/\]\]/, $s);
  s/.*\[\[// for @tags;
  DEBUG "Number of tags: ", scalar @tags;
  DEBUG  join(", ",@tags);

  $to_be_translated_string = $tags_marked;
  # Replace non-translatable string pieces with a 
  # marker that will be ignored by the API. Note loose spacing.
  # Google translate corrupts any text inside the spans,
  # it is not predictable, but it is consistent at least.
  my $ignore_me="<span class = \\'notranslate\\'> || </ span>";
  $to_be_translated_string =~ s/\[\[[^\]]*\]\]/$ignore_me/g;  
}else{
  $to_be_translated_string = $query_string;
}

DEBUG "Translating >>$to_be_translated_string<<";

my $client = REST::Client->new({
  host => "https://translation.googleapis.com"
});

# This key changes every time!
my $key=`gcloud auth application-default print-access-token` || LOGDIE "Failed to get Google Translate key";  

$client->addHeader('Content-Type', 'application/json; charset=utf-8');
$client->addHeader('Authorization', "Bearer $key");
# Translate everything, stuff in brackets may or may not be translated,
# but will be replaced with original replacements in any case.
$client->POST("language/translate/v2", "{ 
  'q'     : '$to_be_translated_string',
  'source': '$source_language',
  'target': '$target_language',
  'format': 'text'
}", undef
); 
# Check for errors
if ( $client->responseCode() != 200 ) {
  my $error_hash=decode_json($client->responseContent());
  my $error_code=$error_hash->{error}->{code};
  my $error_msg =$error_hash->{error}->{errors}->[0]->{message};
  LOGDIE "[$error_code] Translate did not work:  $error_msg" 
}
my $json_hash=decode_json($client->responseContent());
my $translated_text=$json_hash->{data}->{translations}->[0]->{translatedText};

if($linebreak==false){
  # Replace newlines with \n
  $translated_text =~ s/\n/\\n/g;
}

if ( $has_tags == true ) {
  DEBUG "\$translated_text with marked tags: >>$translated_text<<";
  # Replace marked non-translation string-islands with original texts:
  # We are looking for this:
  # <span class = 'notranslate'> || </ span>
  # Sometimes the marks get corrupted by Google. 
  # Corruptions encountered and covered in the regex thus far are:    
  # <span class = 'notranslate'> | </ span>  
  # <span class = 'notranslate' || </ span>
  # <Span class = 'notranslate'> || </ span>
  # <span class = 'notranslate </ span>
  
  # These corruptions need further investigation
  # <span class = 'notranslate' | | <<span> </ span>
  foreach my $tag (@tags){
    $translated_text =~ s/<span class = 'notranslate'?>? \|\|? <\/ span>/$tag/i;     
  }
  DEBUG "\$translated_text with original tags replaced: >>$translated_text<<";
}else{
  DEBUG "\$translated_text: >>$translated_text<<";
}
binmode STDOUT, ":utf8";
print $translated_text;
