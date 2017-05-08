# google-forms-to-plaintext

This is a quick-and-dirty extractor for google forms.  In particular, if you
have a form where most of the questions are long paragraphs, the output
spreadsheet / CSV is pretty much unreadable.

This project turns ugly some CSV such as:

    What is your name,Please paste some lorem lipsum
    Jasper,"Lorem markdownum pectore **oraque resupinoque** palluit sacra dies, at veri
    nitidissima nota rabiem erat Hymettia aevis pignus fugere. Omnis insuper,
    obligor manus.

    - Digitique duxit telluris
    - Meum agger natos
    - Lenita ire humo dixit est forte exemplis
    - Timoris est edentem
    - Nisi simulavimus rapta ut erat nec dixit"

Into a bunch of nice files like:

    What is your name
    =================

      Jasper

    Please paste some lorem lipsum
    ==============================

      Lorem markdownum pectore **oraque resupinoque** palluit sacra dies, at veri
      nitidissima nota rabiem erat Hymettia aevis pignus fugere. Omnis insuper,
      obligor manus.

      - Digitique duxit telluris
      - Meum agger natos
      - Lenita ire humo dixit est forte exemplis
      - Timoris est edentem
      - Nisi simulavimus rapta ut erat nec dixit

One file is created per row in the input CSV.  This project was originally
written to process the Summer of Haskell student applications.
