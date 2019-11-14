︠8618ce8a-cb9d-455a-9840-3ccab424f5c8s︠
#------------------------------Modélisation du Problème de Sequence des Degres d'un Graphe Orienté en un Probleme de Flot Maximum------------------------------------

#------------------------------------------------------------------- Fonctions utilisées en Exercie 1  ------------------------------------------------------
def parcours_largeur(g, Mcapacite, MResiduel, source, puit):
    sommets = g.vertices()
    # on met la source dans la liste des sommets à traiter
    Q = [source]
    n  = Mcapacite.nrows()
    parcours = {source:[]}
    if source == puit:
        return parcours[source]
    while Q:
        #dépiler le permier de la pile
        u = Q.pop(0)
        for v in xrange(n):
            v = sommets[v]
            vf = verifieCaP(Mcapacite, MResiduel, sommets.index(u), sommets.index(v))
            if( vf and v not in parcours):
                parcours[v] = parcours[u]+[(u,v)]
                if v == puit:
                    return parcours[v]
                Q.append(v)
    return None


def recuperCapacite(edges, index):
    return edges[index][2]

def calculeGrapheResi(Edges_capacite, Edge_flow):
    EdgesResiduel = []
    for i in range (0, len(Edges_capacite)):
        #print(Edges_capacite[i])
        r = recuperCapacite(Edges_capacite, i)-recuperCapacite(Edge_flow, i)
        arret = []
        arret.append(Edges_capacite[i][0])
        arret.append(Edges_capacite[i][1])
        arret.append(r)
        EdgesResiduel.append(arret)
    return EdgesResiduel

def calculMinCap(g, Mcapacite, MResiduel,chemin):
    sommets = g.vertices()
    minVal = 100000
    for u,v in chemin :
        val = Mcapacite[sommets.index(u)][sommets.index(v)] - MResiduel[sommets.index(u)][sommets.index(v)]
        if(minVal > val ):
            minVal = val
    return minVal


def Edmonds_Karp( G, Mcapacite, source, puit):
    flow = 0 # notre flot au départ est 0
    sommets = G.vertices();
    length  = Mcapacite.nrows()
    MResiduel = [[0] * length for i in xrange(length)]
    liste_parcours = []
    liste_flowMin = []
    parcours = parcours_largeur(G, Mcapacite, MResiduel, source, puit)
    liste_parcours.append(parcours)
    while parcours != None :
        v = puit
        flow = calculMinCap(G, Mcapacite, MResiduel, parcours)
        liste_flowMin.append(flow)
        for u,v in parcours:
            MResiduel[sommets.index(u)][ sommets.index(v)] = MResiduel[sommets.index(u)][sommets.index(v)] + flow
            MResiduel[sommets.index(v)][sommets.index(u)] = MResiduel[sommets.index(v)][ sommets.index(u)] - flow
            v = u
        parcours = parcours_largeur(G, Mcapacite, MResiduel, source, puit)
        liste_parcours.append(parcours)
    return sum(MResiduel[sommets.index(source)][i] for i in xrange(length)),liste_parcours,liste_flowMin

def verifieCaP(Mcapacite, Mflot, u, v):
    return (Mcapacite[u][v]-Mflot[u][v]>0)


#-------------------------------------------- Nouvelle Fonction pour la Modélisation du Probleme ----------------------------------------------------------------


def transformeListeDeg( DegreeSequence ):
    c = 0
    liste = []
    for s in DegreeSequence :
        diviseSommet = []
        arc = []
        arc.append(c)
        arc.append(s[0])
        c = c + 1
        diviseSommet.append(arc)
        arc = []
        arc.append(c)
        arc.append(s[1])
        diviseSommet.append(arc)
        liste.append(diviseSommet)
        c = c + 1
    return liste

def creeLiaisons(listeSommets):
    edges = []
    for i in range (len(listeSommets)):
        for j in range (len(listeSommets)):
            arret = []
            if i != j:
                s1 = listeSommets[i]
                s2 = listeSommets[j]
                arret.append(s1[0][0])
                arret.append(s2[1][0])
                arret.append(1)
                edges.append(arret)
    return edges


def ajouterSource(edges, listeSommets ):
    for i in range(len(listeSommets)):
        arret = []
        s = listeSommets[i]
        arret.append('s')
        arret.append(s[0][0])
        arret.append(s[0][1])
        edges.append(arret)
    return edges

def ajouterPuit(edges, listeSommets ):
    for i in range(len(listeSommets)):
        arret = []
        s = listeSommets[i]
        arret.append(s[1][0])
        arret.append('t')
        arret.append(s[1][1])
        edges.append(arret)
    return edges


def metteAjourArret(edges):
    edges2 = []
    edges3 = []
    for e in edges:
        arret = []
        arret.append(e[0])
        e[1] = e[1]-1
        arret.append(e[1])
        edges2.append(arret)
    for a in edges2 :
        arret = []
        if a[0] != 0:
            a[0] = a[0]/2
            arret.append(a[0])
        else:
            arret.append(a[0])
        if(a[1] != 0):
            a[1] = a[1]/2
            arret.append(a[1])
        else:
            arret.append(a[1])
        edges3.append(arret)
    return edges3
def constructionDeGraphe(liste_parcours):
    Edges = []
    for j in range (len(liste_parcours)-1):
        p = liste_parcours[j]
        for i in range(1, len(p)-1):
            arret = []
            arret.append(p[i][0])
            arret.append(p[i][1])
            Edges.append(arret)
    Edges = metteAjourArret(Edges)
    return Edges


#---------------------------------------------------------------1er Exemple ------------------------------------------------------------------------
print "\n\n\t\t**************1er Exemple (l'Exemple donné en TP) **************\n\n"
#deg sortant     deg entrant
DegreeSequence = [[3, 2], [3, 2], [1, 2],[1,2]]
print "la sequence des degres est :" , DegreeSequence
print "On transforme chaque sommet en 2 sommets : exemple [3, 2] devient  a = [0, 3] et a' = [1, 2]"
print "a représente les sortants et a' représente les entrants"
listeSommets = transformeListeDeg( DegreeSequence )
print listeSommets
edges = creeLiaisons(listeSommets)
print "On crée un Graphe Biparti orienté de U vers X tel que : U est le sommet sortant et X le sommet entrant "
print "les sortants : [[0, 3], [2, 3], [4, 1], [6, 1]]"
print "les entrants : [[1, 2], [3, 2], [5, 2], [7, 2]]"
print "On fait en sorte de ne pas lier les sortants avec leurs entrants (a avec a' par exemple ==> pour eviter d'avoir des boucles)"
print "On ajoute une Source lié à tous les sortants et un Puit lié à tous les entrants, le poids de l'arete entre la source et le sommet sortant est le degre V+ du sommet, et le poids de l'arete entre le sommet entrant et le puit est le degre V- du sommet, les poids des arrtes entre les sommets sortants et les entrants sont tous à 1"
edges = ajouterSource(edges, listeSommets )
edges = ajouterPuit(edges, listeSommets )

print "Voici le graphe obtenu à la fin :"
g = DiGraph(edges)
g.show(edge_labels = True)
M = g.weighted_adjacency_matrix()

print "\nOn calcule le flot maximal de ce graphe, on utilise l'algorithme de Edmonds_Karp elaborer dans l'exercice 1 "

source = 's'
puit = 't'
fMax,liste_parcours,liste_flowMin= Edmonds_Karp( g, M, 's', 't')
print"Le Flot Maximum pour ce graphe est ======> ", fMax,"\n"
print "Les Chemins Augmentant de la source : "+str(source)+" vers le puit : "+str(puit)+" sont les suivants : "

print("Chemin ===================== Flot Min de ce chemin \n")
for i in range(0, len(liste_parcours)-1) :
    print liste_parcours[i],"=====>",liste_flowMin[i]
listeArretes = constructionDeGraphe(liste_parcours)

print "\nGrace à l'algorithme de Edmonds_Karp on trouve les chemins augmantants de s à t, on trouve donc la liaison entre les arrtes du graphe qu'on veut construire"
print "la liste des arrtes est le suivante: ", listeArretes

print "\nLe graphe finale obtenu pour la sequence des degrés donné est le suivant : "
g1 = DiGraph(listeArretes)
g1.show()
M1 = g.weighted_adjacency_matrix()

#---------------------------------------------------------------2eme Exemple ------------------------------------------------------------------------

print "\n\n\t\t**************2eme Exemple**************\n\n"
DegreeSequence = [[3, 0], [0, 1], [1, 1], [0, 2]]
print "la sequence des degres est :" , DegreeSequence
listeSommets = transformeListeDeg( DegreeSequence )
edges = creeLiaisons(listeSommets)
edges = ajouterSource(edges, listeSommets )
edges = ajouterPuit(edges, listeSommets )

print "le graphe obtenu apres avoir ajouté la Source et le Puit:"
g = DiGraph(edges)
g.show(edge_labels = True)
M = g.weighted_adjacency_matrix()

source = 's'
puit = 't'
print "On passe notre graphe à l'Algorithme de Edmonds Karp"
fMax,liste_parcours,liste_flowMin= Edmonds_Karp( g, M, 's', 't')
print"Le Flot Maximum est ======> ", fMax,"\n"
print "Les Chemins Augmentants de la source : "+str(source)+" vers le puit : "+str(puit)+" sont les suivants : "

print("Chemin ======> Flot min de ce chemin \n")
for i in range(0, len(liste_parcours)-1) :
    print liste_parcours[i],"=====>",liste_flowMin[i]
listeArretes = constructionDeGraphe(liste_parcours)

print "la liste des aretes retouvés grace aux chemins augmentants ", listeArretes
print "\nLe graphe finale obtenu pour la sequence des degrés donné est le suivant : "
g1 = DiGraph(listeArretes)
g1.show()

#--------------------------------------------------------------3eme Exemple -------------------------------------------------------------

print "\n\n\t\t**************3eme Exemple **************\n\n"
DegreeSequence = [[2, 1], [1, 2], [1, 1]]
print "la sequence des degres est :" , DegreeSequence
print "On transforme chaque sommet en 2 sommets : exemple [2, 1] devient  [0, 2] et [1, 1]"
listeSommets = transformeListeDeg( DegreeSequence )
edges = creeLiaisons(listeSommets)
edges = ajouterSource(edges, listeSommets )
edges = ajouterPuit(edges, listeSommets )

print "le graphe obtenu apres avoir ajouté la Source et le Puit:"
g = DiGraph(edges)
g.show(edge_labels = True)
M = g.weighted_adjacency_matrix()

source = 's'
puit = 't'
print "On passe notre graphe à l'Algorithme de Edmonds Karp"
fMax,liste_parcours,liste_flowMin= Edmonds_Karp( g, M, 's', 't')
print"Le Flot Maximum est ======> ", fMax,"\n"
print "Les Chemins Augmentants de la source : "+str(source)+" vers le puit : "+str(puit)+" sont les suivants : "

print("Chemin ======> Flot min de ce chemin \n")
for i in range(0, len(liste_parcours)-1) :
    print liste_parcours[i],"=====>",liste_flowMin[i]
listeArretes = constructionDeGraphe(liste_parcours)
print "la liste des aretes retouvés grace aux chemins augmentants ", listeArretes
print "\nLe graphe finale obtenu pour la sequence des degrés donnés est le suivant : "
g1 = DiGraph(listeArretes)
g1.show()

︡d7e3f7d1-124c-48d7-93e6-a8ab4b293b98︡{"stdout":"\n\n\t\t**************1er Exemple (l'Exemple donné en TP) **************\n\n\n"}︡{"stdout":"la sequence des degres est : [[3, 2], [3, 2], [1, 2], [1, 2]]\n"}︡{"stdout":"On transforme chaque sommet en 2 sommets : exemple [3, 2] devient  a = [0, 3] et a' = [1, 2]\n"}︡{"stdout":"a représente les sortants et a' représente les entrants\n"}︡{"stdout":"[[[0, 3], [1, 2]], [[2, 3], [3, 2]], [[4, 1], [5, 2]], [[6, 1], [7, 2]]]\n"}︡{"stdout":"On crée un Graphe Biparti orienté de U vers X tel que : U est le sommet sortant et X le sommet entrant \n"}︡{"stdout":"les sortants : [[0, 3], [2, 3], [4, 1], [6, 1]]\n"}︡{"stdout":"les entrants : [[1, 2], [3, 2], [5, 2], [7, 2]]\n"}︡{"stdout":"On fait en sorte de ne pas lier les sortants avec leurs entrants (a avec a' par exemple ==> pour eviter d'avoir des boucles)\n"}︡{"stdout":"On ajoute une Source lié à tous les sortants et un Puit lié à tous les entrants, le poids de l'arete entre la source et le sommet sortant est le degre V+ du sommet, et le poids de l'arete entre le sommet entrant et le puit est le degre V- du sommet, les poids des arrtes entre les sommets sortants et les entrants sont tous à 1\n"}︡{"stdout":"Voici le graphe obtenu à la fin :\n"}︡{"file":{"filename":"/home/user/.sage/temp/project-52f678b6-f45c-431d-9478-1c09e440f5f7/199/tmp__uN5kh.svg","show":true,"text":null,"uuid":"a8fe4e76-2107-47d6-b0fa-ad3dfca33693"},"once":false}︡{"stdout":"\nOn calcule le flot maximal de ce graphe, on utilise l'algorithme de Edmonds_Karp elaborer dans l'exercice 1 \n"}︡{"stdout":"Le Flot Maximum pour ce graphe est ======>  8 \n\n"}︡{"stdout":"Les Chemins Augmentant de la source : s vers le puit : t sont les suivants : \n"}︡{"stdout":"Chemin ===================== Flot Min de ce chemin \n\n"}︡{"stdout":"[('s', 0), (0, 3), (3, 't')] =====> 1\n[('s', 0), (0, 5), (5, 't')] =====> 1\n[('s', 0), (0, 7), (7, 't')] =====> 1\n[('s', 2), (2, 1), (1, 't')] =====> 1\n[('s', 2), (2, 5), (5, 't')] =====> 1\n[('s', 2), (2, 7), (7, 't')] =====> 1\n[('s', 4), (4, 1), (1, 't')] =====> 1\n[('s', 6), (6, 3), (3, 't')] =====> 1\n"}︡{"stdout":"\nGrace à l'algorithme de Edmonds_Karp on trouve les chemins augmantants de s à t, on trouve donc la liaison entre les arrtes du graphe qu'on veut construire\n"}︡{"stdout":"la liste des arrtes est le suivante:  [[0, 1], [0, 2], [0, 3], [1, 0], [1, 2], [1, 3], [2, 0], [3, 1]]\n"}︡{"stdout":"\nLe graphe finale obtenu pour la sequence des degrés donné est le suivant : \n"}︡{"file":{"filename":"/home/user/.sage/temp/project-52f678b6-f45c-431d-9478-1c09e440f5f7/199/tmp_9_ZMhS.svg","show":true,"text":null,"uuid":"47b1a086-baba-4b99-8059-2fb4b69406a5"},"once":false}︡{"stdout":"\n\n\t\t**************2eme Exemple**************\n\n\n"}︡{"stdout":"la sequence des degres est : [[3, 0], [0, 1], [1, 1], [0, 2]]\n"}︡{"stdout":"le graphe obtenu apres avoir ajouté la Source et le Puit:\n"}︡{"file":{"filename":"/home/user/.sage/temp/project-52f678b6-f45c-431d-9478-1c09e440f5f7/199/tmp_2vVbu_.svg","show":true,"text":null,"uuid":"0a94fd4d-8546-4090-ba29-83c0282897be"},"once":false}︡{"stdout":"On passe notre graphe à l'Algorithme de Edmonds Karp\n"}︡{"stdout":"Le Flot Maximum est ======>  4 \n\n"}︡{"stdout":"Les Chemins Augmentants de la source : s vers le puit : t sont les suivants : \n"}︡{"stdout":"Chemin ======> Flot min de ce chemin \n\n"}︡{"stdout":"[('s', 0), (0, 3), (3, 't')] =====> 1\n[('s', 0), (0, 5), (5, 't')] =====> 1\n[('s', 0), (0, 7), (7, 't')] =====> 1\n[('s', 4), (4, 7), (7, 't')] =====> 1\n"}︡{"stdout":"la liste des aretes retouvés grace aux chemins augmentants  [[0, 1], [0, 2], [0, 3], [2, 3]]\n"}︡{"stdout":"\nLe graphe finale obtenu pour la sequence des degrés donné est le suivant : \n"}︡{"file":{"filename":"/home/user/.sage/temp/project-52f678b6-f45c-431d-9478-1c09e440f5f7/199/tmp_cRpTeB.svg","show":true,"text":null,"uuid":"addf1b8b-b215-48e4-b313-1d0ef983ab63"},"once":false}︡{"stdout":"\n\n\t\t**************3eme Exemple **************\n\n\n"}︡{"stdout":"la sequence des degres est : [[2, 1], [1, 2], [1, 1]]\n"}︡{"stdout":"On transforme chaque sommet en 2 sommets : exemple [2, 1] devient  [0, 2] et [1, 1]\n"}︡{"stdout":"le graphe obtenu apres avoir ajouté la Source et le Puit:\n"}︡{"file":{"filename":"/home/user/.sage/temp/project-52f678b6-f45c-431d-9478-1c09e440f5f7/199/tmp_FZ8iIg.svg","show":true,"text":null,"uuid":"5c255c39-de85-4d73-8557-fd47e53156a3"},"once":false}︡{"stdout":"On passe notre graphe à l'Algorithme de Edmonds Karp\n"}︡{"stdout":"Le Flot Maximum est ======>  4 \n\n"}︡{"stdout":"Les Chemins Augmentants de la source : s vers le puit : t sont les suivants : \n"}︡{"stdout":"Chemin ======> Flot min de ce chemin \n\n"}︡{"stdout":"[('s', 0), (0, 3), (3, 't')] =====> 1\n[('s', 0), (0, 5), (5, 't')] =====> 1\n[('s', 2), (2, 1), (1, 't')] =====> 1\n[('s', 4), (4, 3), (3, 't')] =====> 1\n"}︡{"stdout":"la liste des aretes retouvés grace aux chemins augmentants  [[0, 1], [0, 2], [1, 0], [2, 1]]\n"}︡{"stdout":"\nLe graphe finale obtenu pour la sequence des degrés donnés est le suivant : \n"}︡{"file":{"filename":"/home/user/.sage/temp/project-52f678b6-f45c-431d-9478-1c09e440f5f7/199/tmp_5YB8qk.svg","show":true,"text":null,"uuid":"5e972f2a-e78f-4175-9d00-7377367768fa"},"once":false}︡{"done":true}︡
︠c34807ad-4d2f-4abb-9b63-93254eb31ee7︠

︡23647a16-f75b-4b87-b452-afd923282afa︡
︠b2bd8a58-8525-403e-92e4-1e1454a5a5a8︠

︡a06884fc-1529-4bcf-bbd9-dc8767e135a5︡
︠ca6b88ed-4c60-4181-9b2e-36d43022cd46s︠

︡2e2bc1c0-cdc2-4f9d-9558-66ffbdf0f7c9︡{"done":true}︡︡︡︡
︠871727e3-f502-405d-9a3f-207830a32a19s︠

︡b9d72494-cde5-4682-aebc-24168aac2c9b︡{"done":true}︡
︠c4a035e6-6f99-4333-a175-0a9fe15ee708︠

︡67692570-1846-4835-8212-64702bf93f1a︡
︠b3eb72f3-7593-4e72-b8bd-4f658e829369s︠

︡f8812998-5cee-41fc-84a5-99c6480792a4︡{"done":true}︡









