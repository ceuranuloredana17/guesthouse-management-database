INSERT INTO CLIENTI (ID_Client, Nume, Prenume, Email, Telefon) 
VALUES (10, 'Marinescu', 'Ioana', 'marinescu.ioana@gmail.com', '0722000000');


UPDATE CLIENTI 
SET Email = 'ioana23marinescu@gmail.com' 
WHERE ID_Client = 10;


DELETE FROM CLIENTI 
WHERE ID_Client = 2;


INSERT INTO REZERVARI_SERVICII_EXTRA (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, DataRezervare)
VALUES (4, 5, 1, TO_DATE('2023-05-01', 'YYYY-MM-DD'));


INSERT INTO REZERVARI (ID_Rezervare, ID_Client, ID_Camera, DataInceput, DataSfarsit, Status) 
VALUES (10, 10, 11, TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-05', 'YYYY-MM-DD'), 'Confirmat');


INSERT INTO PLATI (ID_Plata, ID_Rezervare, Suma, DataPlata, Modalitate) 
VALUES (10, 10, 1600.00, TO_DATE('2023-07-01', 'YYYY-MM-DD'), 'Card');


UPDATE CLIENTI 
SET Email = 'ceuranu.loredana17@gmail.com' 
WHERE ID_Client = 6;


INSERT INTO SERVICII_EXTRA (ID_Serviciu, Denumire, Pret, Descriere) 
VALUES (4, 'TRANSPORT', 100.00, 'Transport aeroport pentru două persoane');


INSERT INTO SERVICII_EXTRA (ID_Serviciu, Denumire, Pret, Descriere) 
VALUES (5, 'Inchirieri Biciclete', 50.00, 'Inchirieri biciclete pentru două persoane');


INSERT INTO SERVICII_EXTRA (ID_Serviciu, Denumire, Pret, Descriere) 
VALUES (6, 'SAUNA', 60.00, 'SAUNA pentru doua persoane');


SELECT * FROM PLATI WHERE ID_Plata IN (7, 8, 9);


SELECT * FROM PLATI WHERE Suma >= 1000;


SELECT * FROM CLIENTI WHERE ID_Client BETWEEN 4 AND 7;

SELECT ID_Camera, COUNT(*) AS total_reservations
FROM REZERVARI
WHERE Status = 'Confirmat'
  AND EXTRACT(MONTH FROM DataInceput) = 5
  AND EXTRACT(YEAR FROM DataInceput) = 2023
GROUP BY ID_Camera
ORDER BY ID_Camera ASC;

SELECT * FROM REZERVARI
WHERE Status = 'Confirmat'
  AND DataInceput >= TO_DATE('2023-04-10', 'YYYY-MM-DD')
  AND DataInceput <= TO_DATE('2023-04-15', 'YYYY-MM-DD');


SELECT * FROM PLATI WHERE Suma BETWEEN 400 AND 1200
MINUS
SELECT * FROM PLATI WHERE Suma IN (600.00, 1000.00);

SELECT ID_Rezervare, SUM(Suma) AS TotalSuma
FROM PLATI
GROUP BY ID_Rezervare
HAVING SUM(Suma) > 500.00;

SELECT R.*, SE.Denumire, SE.Pret
FROM REZERVARI R
LEFT JOIN REZERVARI_SERVICII_EXTRA RSE ON R.ID_Rezervare = RSE.ID_Rezervare
LEFT JOIN SERVICII_EXTRA SE ON RSE.ID_Serviciu = SE.ID_Serviciu;


SELECT EXTRACT(YEAR FROM DataInceput) AS Anul FROM REZERVARI;


SELECT R.*, C.Nume, C.Prenume
FROM REZERVARI R
LEFT JOIN CLIENTI C ON R.ID_Client = C.ID_Client;


SELECT NumarCamera, Tip,
  DECODE(Tip,
    'Dubla Standard', 'Standard Room',
    'Dubla Superior', 'Superior Room',
    'Dubla Lux', 'Luxury Room',
    'Single', 'Single Room',
    'APARTAMENT', 'Apartment'
  ) AS RoomCategory
FROM CAMERE;


SELECT *
FROM CAMERE c1
WHERE c1.PretNoapte > ANY (
  SELECT c2.PretNoapte FROM CAMERE c2 WHERE c2.ID_Camera <> c1.ID_Camera
);


SELECT r.ID_Rezervare, r.ID_Client, r.ID_Camera,
       r.DataInceput AS DataInceputRezervare,
       r.DataSfarsit AS DataSfarsitRezervare,
       r.Status AS StatusRezervare,
       p.ID_Plata, p.Suma, p.DataPlata, p.Modalitate
FROM REZERVARI r
INNER JOIN PLATI p ON r.ID_Rezervare = p.ID_Rezervare
WHERE p.DataPlata BETWEEN r.DataInceput AND r.DataSfarsit;


SELECT p.ID_Plata,
       TO_CHAR(p.DataPlata, 'DD-MON-YYYY') AS DataPlataFormatata,
       TO_CHAR(p.Suma, '999,999.99') AS SumaFormatata,
       r.ID_Rezervare,
       TO_CHAR(r.DataInceput, 'DD-MON-YYYY') AS DataInceputFormatata,
       TO_CHAR(r.DataSfarsit, 'DD-MON-YYYY') AS DataSfarsitFormatata
FROM PLATI p
JOIN REZERVARI r ON p.ID_Rezervare = r.ID_Rezervare;

SELECT Nume, LEVEL AS nv
FROM ANGAJATI_PENSIUNE
START WITH ID_Manager IS NULL
CONNECT BY PRIOR Id_Angajat = ID_Manager
ORDER BY LEVEL, Nume;

CREATE VIEW VIEW_PLATI_REZERVARI AS
SELECT r.ID_Rezervare, r.ID_Client, r.ID_Camera, r.DataInceput, r.DataSfarsit, r.Status,
       p.ID_Plata, p.Suma, p.DataPlata AS DataPlataPlati, p.Modalitate
FROM REZERVARI r
LEFT JOIN PLATI p ON r.ID_Rezervare = p.ID_Rezervare;


CREATE INDEX IDX_VIEW_PLATI_REZERVARI
ON VIEW_PLATI_REZERVARI (ID_Rezervare, DataPlataPlati);

CREATE SEQUENCE SEQ_ID_CLIENT
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

