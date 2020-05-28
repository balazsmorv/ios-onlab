# TVDB
[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

A TVDB megkönnyíti az esti TV-zés előtti hosszas gondoldásokat, az épp futó műsorok rangsorolásával, IMDB pontszám szerint.

  - Állítsa be milyen csatornákról szeretne javaslatokat kapni
  - Böngéssze a találatokat a listanézetben, a pontszámokkal.
  - Bökjön rá egy találatra, és kapjon jöbb infót, mint a poszterkép és hogy melyik csatornán megy éppen a műsor

### Felhasznált technológiák

TVDB app az alábbi technológiákat használja:

* Swift - Az alkalmazás Swift nyelvben lett megírva
* SwiftUI - a megjelenítéshez
* NSURLSession - adatok letöltéhez, api használathoz
* API: https://rapidapi.com/rapidapi/api/movie-database-imdb-alternative?endpoint=apiendpoint_843d3708-42a9-4240-8a68-2ced0372c20f
* API: https://rapidapi.com/hmerritt/api/imdb-internet-movie-database-unofficial?endpoint=apiendpoint_712d7dac-5b49-489c-888b-04c774a2964c
* XML TV műsorújság: https://guidex.ml/
* Combine framework a View és Model összekötéséhez
* Perzisztens adattárolás UserDefaults-szal és az Application Support mappába írással
* XMLParser a Foundation frameworkből

### Fileok

* AppDelegate.swift
* SceneDelegate.swift
* Movie.swift - modell része, műsorokat kér le, tárol el
* TVGuide.swift - modell része, műsorújságot tölt le xml formátumba, parseolja, formázza
* IDInfo.swift - modell része, segédstruktúrák
* Listview.swift - view része, a listanézetért felel
* MovieListRowView - view része, a listanézet elemei
* MovieView - view része, a részletes műsornézetet definiálja
* MainView - view része, TabBart definiál az alján
* SettingsView - view része, itt tudja kiválasztani a felhasználó, milyen csatornákról szeretne javaslatokat kapni
* ios6styleButton - just for fun, sehol nincs benne az alkalmazásban

### Telepítés

A projektet letöltve lehet Simulatorban futtatni, legalább Xcode 11 szükséges hozzá.
Az alkalmazás futtatásához legalább iOS 13 operációs rendszer szükséges, vagy Mac OS X 10.15


### Todo

 - Felhasználó válaszhassa ki az őt érdeklő csatornákat (a view már megvan hozzá, de még be kell kötni)
 - Time out errorok problémájának megoldása amikor egyszerre sok kérést küld az app (> 20) - pl késleltetéssel
 - Több információt kiírni a képernyőre a részletezett viewban
 - Frissítés megoldása az app ujraindítása nélkül
 - API eredmények hitelességének vizdgálata a fals eredmények kiszűrése érdekében
 - Az app iPades és Maces verziójának a kinézetét módosítani, hogy ne ugyanúgy nézzen ki mint az iPhone-os verzió
