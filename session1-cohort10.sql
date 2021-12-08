/* SELECT */
/* tracks tablosundaki 	isimleri (name) sorgulayin SORGULAYIN */
SELECT name FROM tracks;

/* track tablosundaki besteci (Composer) ve sarki isimlerini (name) sorgulayiniz */
SELECT Composer,name FROM tracks;

-- tracks tablosundaki tum bilgileri sorgulayiniz --
SELECT * FROM tracks;

/* DISTINCT tekrarsiz sutunlari almak icin kullanilir. Tekrarlayan isimleri tek alir */
SELECT Composer FROM tracks;

SELECT DISTINCT Composer FROM tracks;

/* tracks tablosundaki AlbumId ve MediaTypeId bilgilerini tekrarsiz olarak sorgulayiniz.*/
SELECT DISTINCT AlbumId, MediaTypeId FROM tracks;

/* WHERE kosul yapiminda kullanilir.  Composer'i Jimi Hendrix olanlarin name'ini getirin */
SELECT name 
FROM tracks 
WHERE Composer='Jimi Hendrix';

/* invoices tablosundaki total degeri $ dan buyuk olan faturalarin tum bilgilerini sorgulayiniz */
SELECT *
 FROM invoices 
 WHERE total>10;
	