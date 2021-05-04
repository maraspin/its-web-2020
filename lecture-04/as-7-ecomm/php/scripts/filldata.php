#!/usr/bin/php
<?php
include(__DIR__ . "/../config.inc.php");

try {
	$db = new PDO($dsn , $username, $password);
	$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	// Procedura Creazione Prodotti
	echo "Generazione di nomi random in corso...\n";
	$namebase = array('pingo', 'pongo', 'bum', 'bam', 'foo',
	'baz', 'bar', 'pogo', 'dogo', 'sole',
	'luna', 'volo', 'air', 'fire', 'tee');
	$prodottovariante = 0;

	$db->beginTransaction();
	$ai_prodId = array();

	for ($x=0; $x< 60000; $x++) {
		
		// 7 è il numero delle categorie (ID da 1 a 7)
		$categoria = rand(1, 7);

		$prezzo = (rand(25, 3500) / 10);
		$visti = rand (0, 5000);
		$dataarrivo = '2015-01-'.rand(1,31).' '.rand(1,23).':'.rand(0,59);
		$namebaseel = count($namebase) - 1;
		$nome = $namebase[rand(0, $namebaseel)].$namebase[rand(0, $namebaseel)];
		if (rand(0,1) == 1) {
			$nome .= " ".$namebase[rand(0, $namebaseel)];
		}
		$nome = ucwords(strtolower($nome));

		// L'ID è restituito dalla Sequenza (nextval)
		$db->exec("INSERT INTO prodotti (nome, descrizione, prezzo, visite, dataarrivo, categoria_id) VALUES ('". 
		$nome ."','".$nome."',".$prezzo.",".$visti.",'".$dataarrivo."',".$categoria.")");

		// Lastinsert ci torna l'ID associato dalla sequenza al prodotto
		$prod_id = $db->lastInsertId('prodotti_id_seq');
		echo "Prodotto ".$nome." (".$prod_id.") creato\n";

		for ($v = 1; $v<10; $v++) {
			// Ci sono il 25% di possibilità per un articolo di essere disponibile in un certo colore
			// Eccezione che per il nero, dove le possibilità sono il 55%
			if (rand(0,100) > 75 || (1==$v && rand(0,100) > 45)) {
				$db->exec("INSERT INTO prodottivarianti (prodotto_id, variante_id) VALUES (".$prod_id.",".$v.")");
			}
		}
		echo "Varianti per il Prodotto ".$nome." create\n";
	}
	$db->commit();
} catch(PDOException $e) {
	echo 'Errore nel dialogo con il Database: '.$e->getMessage()."\n";
}
