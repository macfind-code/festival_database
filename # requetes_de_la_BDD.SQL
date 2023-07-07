# Projet SQL Hetic


-- ### Groupe 1 : SELECT (Sans jointures)

1. Lister le nom et le prénom des musiciens, ordonnées par leur date de naissance

SELECT last_name, first_name, birthdate FROM artist ORDER BY birthdate;

-- 200 résultats

2. Lister le nom et la capacité des lieux disponibles, ordonnés par capacité croissante

SELECT name, max_spectators FROM place ORDER BY max_spectators;

-- 5 résultats

3. Lister les 5 prochains concerts

SELECT start_time FROM event ORDER BY start_time LIMIT 5;

-- 5 résultats

-- ### Groupe 2 : WHERE

1. Lister les spectateurs originaires de **Croatie**

SELECT first_name, last_name, country FROM spectateur WHERE country='Croatia';

-- 7 résultats

2. Lister les musiciens nés entre 1970 et 1990

SELECT first_name, last_name, birthdate FROM artist WHERE birthdate >= '1970' and birthdate <='1990';

-- 108 résultats

3. Lister les spectateurs dont le nom commence par **B** et nés avant 1970

SELECT last_name, first_name, birthdate FROM spectateur WHERE last_name LIKE 'B%' AND birthdate > '1970';

-- 27 résultats

4. Lister les concerts (id et date) par ordre chronologique

SELECT id, date FROM event ORDER BY date asc;

-- 14 résultats

-- ### Groupe 3 : JOIN

1. Lister les concerts et  afficher les artistes présent à chacun d’eux

SELECT concert.id, artist.first_name, artist.last_name FROM concert_part JOIN artist ON artist.id = concert_part.artist_id JOIN concert ON concert.id = concert_part.concert_id;

-- 15 résultats

2. Lister les concerts en indiquant le lieu dans lequel ils se déroulent

SELECT C.id, p.name FROM concert as C INNER JOIN EVENT AS E ON E.id = C.id INNER JOIN place AS P ON P.id = E.place_id;

-- 10 résultats

3. Lister les instruments de chaque groupe

select distinct G.name,A.instrument from `group` as G
inner join artist_group as AG on G.id = AG.group_id
inner join artist as A on AG.artist_id= A.id;

-- 163 résultats

4. Lister les concerts auxquels va assister **Retha Dookie**, avec la liste des membres du groupe, le lieu et la date/heure

SELECT event.id, artist.first_name, artist.last_name, place.name, event.start_time
FROM spectateur
INNER JOIN ticket ON spectateur.id = ticket.spectator_id
INNER JOIN concert_part ON ticket.concert_id = concert_part.concert_id
INNER JOIN `group` ON concert_part.artist_id = `group`.id
INNER JOIN artist_group ON `group`.id = artist_group.group_id
INNER JOIN artist ON artist_group.artist_id = artist.id
INNER JOIN event ON ticket.concert_id = event.id
INNER JOIN place ON event.place_id = place.id
WHERE (spectateur.first_name = 'Retha') AND (spectateur.last_name = 'Dooley')

-- 22 résultats

5. Calculer le panier moyen des ventes

select AVG(P.price) from spectateur as S
inner join ticket as T on S.id = T.spectator_id
inner join price as P on T.price_id= P.id;

-- 1 résultat

6. Lister qui est en première et seconde partie de chaque concert (et indiquer s’il n’y a personne)

SELECT concert_part

7. Lister les salles/lieux et les contraintes techniques de chacune.

select P.name,T.equipment from place as P
inner join technical_constraints_place as tcp on P.id= TCP.place_id
inner join technical_constraints as T on TCP.technical_constraints_id = T.id;

-- 10 résultats

8. Lister les groupes  et les salles où ils se produisent

select G.name, P.name from `group` as G
inner join concert_part as CP on G.id = CP.artist_id
inner join event as E on CP.concert_id = E.id
inner join place as P on P.id = E.place_id;

-- 15 résultats

### Groupe 4 : GROUP BY

1. Lister les groupes et leur nombre de membres.

select group_id as groupes ,count(artist_id) as "nombre de membres "from artist_group
group by group_id;

-- 60 résultats

2. Lister les concerts en indiquant le nombre de places vendues.

select concert_id,count(spectator_id) as "ticket vendu"  from ticket
group by concert_id;

-- 10 résultats

3. Lister le total des ventes pour chaque journée de festival (en se basant sur `startTime`)

SELECT date(event.start_time), SUM(price)
FROM event
JOIN ticket on ticket.concert_id = event.id
JOIN price ON price.id = ticket.price_id
GROUP BY date(event.start_time)

-- 8 résultats

4. Lister la moyenne du montant des ventes pour chaque concert

select T.concert_id,round(avg(P.price),2) as "moyenne du montant des ventes" from ticket as T
inner join price as P on T.price_id=P.id
group by concert_id;

-- 10 résultats

5. Lister les concerts qui ont rassemblé plus de 100 spectateurs

select concert_id,count(spectator_id) as "ticket vendu"  from ticket
where "ticket vendu" >= "100"
group by concert_id;

-- 5 résultats

### Groupe 5 : Requêtes ensemblistes

1. Lister les nom, prénom de ceux qui font le festival : Artistes et Bénévoles.

select first_name, last_name from staff
union
select first_name, last_name from artist;

-- 210 résultats

2. Pour les téméraires : reprenez la requête précédente et ajouter une colonne indiquant le rôle (artiste ou bénévole) de chacun.

SELECT first_name, last_name, 
       CASE WHEN EXISTS (SELECT 1 FROM artist WHERE artist.first_name = staff.first_name AND artist.last_name = staff.last_name)
            THEN 'artiste'
            ELSE 'benevole'
       END AS type_personne
FROM staff
UNION
SELECT first_name, last_name, 'artiste' AS type_personne
FROM artist;

-- 210 résultats
