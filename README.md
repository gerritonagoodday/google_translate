# NAME

google\_translate.pl: Translates any arbitrary text from one language to another. 

It also preserves formatting tags (e.g. %1$s, %03c, %d, %e), substitution tags (e.g. {} and \[\]}), 
programming functions names (class::method) and HTML tags in the input text in the same order as 
they were encountered. The results are unpredictable when the translated-to language necessarily
requires a sentence-part rearrangement. You should manually check that the tags are in the correct context.

This uses Google Translate API Version 2.0. Look out for a future version that uses Google Translate API V3.
The translation quality is already very good compared to Version 1.0, but you should always manually 
check the resulting translation to avoid embarassment or offence. 

The output if sent to STDOUT. Here is what you can do with it in, say, the BASH shell:

    ~ $ a=$(./google_translate.pl -q "Hello %s, my name is Jeff, the god of biscuits." -s en -t de 2>/dev/null)
    ~ $ printf "$a\n" Peter
    Hallo Peter, mein Name ist Jeff, der Gott der Kekse.

# SYNOPSIS

If you are an Eddie Izzard fan try this. Information and debug messages go to _stderr_, hence the `<2`/dev/null>> redirection:

    ./google_translate.pl -s en -t de -q 'Hello world, my name is Jeff, the god of biscuits.' 2>/dev/null

This returns:

    Hallo Welt, ich heiße Jeff, der Gott der Kekse.

# OPTIONS

`./google_translate.pl **-s|--source** _langauge_ **-t|--target** _langauge_ **-q|--query** _'text to be translated'_ [-d|--debug] [-m|--man]`

## Mandatory

- **-s|--source**

    ISO639.1 Language to translate from, see below.

- **-t|--target**

    ISO639.1 Language to translate to, see below.

- **-q|--query**

    String to be translated, in inverted commas. Remember to escape embedded embedded inverted commas.

## Optional

- **-d|--debug**

    Debug mode - displays lots of messages in the error log

- **-m|--man**

    Help - displays the man page for this script

## Optional Advanced

- **-l|--linebreak**

    Break output lines according to the input linebreaks. 
    By default, multi-line output will be merged into a single line 
    with actual two characters '\\n' that more-or-less correspond to linebreaks 
    in the source text.

# Setting yourself up to use Google Cloud Platform API services

See [https://cloud.google.com/translate/](https://cloud.google.com/translate/).

You need to have a Google account. A good start is to get a GMail account. 
Then you need to become a Google Cloud Platform user, which means you need to
provide payment details. For the amount of expected use of the Google Translate 
API, you are unlikely to ever need to pay, but check out the costs as greed 
always eventually wins.

Download and install the Google Cloud Platform SDK. Got to 
[https://cloud.google.com/translate/docs/quickstart](https://cloud.google.com/translate/docs/quickstart) 
and follow the steps for version 2.0: Set up a Google Cloud Platform project 
if you don't already have one that you can piggy-back off in the GCP console.
Download your private key as a JSON file and keep in a place where it is safe
(a naughty person could run charges up if this falls in the wrong hands)
and will not be deleted, e.g. `<${HOME}/.gcp/v2/[projectname]-[id].json`>.
Set this environment variable:

    $ export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/.gcp/[projectname]-[id].json"

Add this line above to your ~/.bashrc file. Use `<${HOME}`>, not `<~`>. 
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

# Supported Languages:

These are the languages supported by Google Translate as of April 2019, with the ISO639.1/2 code to use:

**Afrikaans** af, **Albanian** sq, **Amharic** am, **Arabic** ar, **Armenian** hy, **Azerbaijani** az, **Basque** eu, 
**Belarusian** be, **Bengali** bn, **Bosnian** bs, **Bulgarian** bg, **Catalan** ca, **Cebuano** ceb (ISO-639-2), 
**Chinese (Simplified)** zh-CN, **Chinese (Traditional)** zh-TW, **Corsican** co, **Croatian** hr, **Czech** cs, 
**Danish** da, **Dutch** nl, **English** en, **Esperanto** eo, **Estonian** et, **Finnish** fi, **French** fr, 
**Frisian** fy, **Galician** gl, **Georgian** ka, **German** de, **Greek** el, **Gujarati** gu, **Haitian Creole** ht, 
**Hausa** ha, **Hawaiian** haw (ISO-639-2), **Hebrew** he\*\*, **Hindi** hi, **Hmong** hmn (ISO-639-2), **Hungarian** hu, 
**Icelandic** is, **Igbo** ig, **Indonesian** id, **Irish** ga, **Italian** it, **Japanese** ja, **Javanese** jw, 
**Kannada** kn, **Kazakh** kk, **Khmer** km, **Korean** ko, **Kurdish** ku, **Kyrgyz** ky, **Lao** lo, **Latin** la, 
**Latvian** lv, **Lithuanian** lt, **Luxembourgish** lb, **Macedonian** mk, **Malagasy** mg, **Malay** ms, 
**Malayalam** ml, **Maltese** mt, **Maori** mi, **Marathi** mr, **Mongolian** mn, **Myanmar (Burmese)** my, 
**Nepali** ne, **Norwegian** no, **Nyanja (Chichewa)** ny, **Pashto** ps, **Persian** fa, **Polish** pl, 
**Portuguese** pt, **Punjabi** pa, **Romanian** ro, **Russian** ru, **Samoan** sm, **Scots Gaelic** gd, 
**Serbian** sr, **Sesotho** st, **Shona** sn, **Sindhi** sd, **Sinhala** si, **Slovak** sk, **Slovenian** sl, 
**Somali** so, **Spanish** es, **Sundanese** su, **Swahili** sw, **Swedish** sv, **Tagalog** tl, **Tajik** tg, 
**Tamil** ta, **Telugu** te, **Thai** th, **Turkish** tr, **Ukrainian** uk, **Urdu** ur, **Uzbek** uz, **Vietnamese** vi, 
**Welsh** cy, **Xhosa** xh, **Yiddish** yi, **Yoruba** yo, **Zulu** zu

## Notes:

To update the README file, do this:

    pod2markdown google_translate.pl > README.md

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 70:

    You forgot a '=back' before '=head2'

- Around line 72:

    '=item' outside of any '=over'
