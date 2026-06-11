Come ogni Linguaggio (che si rispetti) si finisce un istruzione con il `;`.
es: 
```dart
final databse = AppDatabase();
```
Stessa cosa per i commenti:

```dart
// commento
/// Commento che esce in aiuto o supporto. Commento "documentale".
/*Commento
più
righe*/
```

# Variabili:
```dart
int stipendio = 799;
String nome = "mario";
double prezzo = 22.89;
bool attivo = true;
DateTime data = DateTime.now();
```
# Final:
```dart
final database = AppDatabase();
```

`final` significa che la variabile può ricevere un valore, una sola volta.
es:
```dart
final nome = "Mario"; // va bene
nome = "Luigi"; // Non va più bene
```

## Differenza con `Const`.
Const rappresenta un valore conosciuto durante la compilazione. Final non ne ha bisogno:
```dart
const x = 5; // va bene
const y = DateTime.now() // non va bene, non so il valore finchè non lo eseguo.
final y = DateTime.now() // va bene, non importa.
```
## Late
Esiste anche `Late Final`.
Late significa che verrà inizializzata dopo la creazione dell'oggetto, ma prima di essere utilizzata.

Questo è estremamente utile per Drift a livello di tabelle database.
```
late final id = integer().autoIncrement()();
===========
late
→ verrà inizializzato successivamente

final
→ dopo l’inizializzazione non cambierà

id
→ nome della proprietà
```

# Valori Nulli
In dart le variabili normali non possono essere null se non dichiarate per bene.
```dart
String nome; // non può essere null, deve avere un valore
String? nome; // può esser null
```

il `?` serve per indicare che il valore può essere assente.
nei database:

```dart
late final notes = text().nullable()();
```
Significa che notes può essere vuota.

# Classi
Una classe è un modello utilizzato per creare oggetti.
```dart
class Persona 
{  
	String nome;  
	int eta;  
	Persona({   
		required this.nome,    
		required this.eta,  
	});
}
```

Da qui si può creare un oggetto:
```dart
final persona = Persona(  
nome: 'Mario',  
eta: 30,  
);
```

Nel progetto ci sono classi come:
```dart
class AppDataBase
class AppSettings
class DatabaseTestPage
```
Ognuno ha una responsabilità diversa.

# Funzioni.
Una funzione esegue un’operazione.

```dart
int somma(int a, int b) 
{  
	return a + b;
}
```

Analizziamola:

```
int
→ tipo del valore restituito

somma
→ nome della funzione

(int a, int b)
→ parametri ricevuti

return a + b
→ risultato
```

Utilizzo:

```dart
final risultato = somma(5, 3);
```

Il risultato è `8`.

# Parametri nominati.
Flutter utilizza invece attributi html nominati nel codice.

```dart
Text(
	'Titolo',
	textAlign: TextAlign.center,
)
```

`textAlign` è un parametro nominato.

in una funzione personalizzata:

```dart
void creaUtente({
	required String nome,
	required int eta,
})
{
//codice
}
```

Utilizzo:

```dart
creaUtente(
  nome: 'Mario',
  eta: 30,
);
```

`required` significa che il parametro è obbligatorio.

Letto questo -> [DataBase (definire le Tabelle)](DataBase%20(definire%20le%20Tabelle).md).