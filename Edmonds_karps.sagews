︠bb0ff814-366c-4ed0-90b6-dcb2b08e3efc︠

#------------------------------------------------------------------ Les Fonctions Utilisées ---------------------------------------------------------------------

BLANC = 'B';
GRIS = 'G';
NOIR = 'N';

#pour faire la structure adaptée
# on change le parcours en largeur pour qu'il s'adapte à l'algo
def parcours_largeur(g, Mcapacite, MResiduel, source, puit):
    sommets = g.vertices()
    # on met la source dans la liste des sommets à traiter
    Q = [source]
    n  = Mcapacite.nrows()
    parcours = {source:[]}
    parent = {};
    if source == puit:
        return parcours[source]
    while Q:
        #dépiler le permier de la pile
        u = Q.pop(0)
        u_voisins = []
        #recuperer la liste de ses voisins out
        u_voisins = g.neighbors_out(u)
        parent[u] = [];
        for v in range(n):
            v = sommets[v] # le v est l'indice du sommet, sommets[v] nous retourne le sommet lui meme
            # on verifie que sa capacité peut encore passer des unités demandées
            vf = verifieCaP(Mcapacite, MResiduel, sommets.index(u), sommets.index(v))
            # on verifie qu'il n'est pas encore marqué
            if( vf and v not in parcours):
                parcours[v] = parcours[u]+[(u,v)]
                if v == puit:
                    # si je suis ici c'est à dire que j'ai trouvé mon chemin augmentant donc je le retourne
                    return parcours[v]
                # si je suis ici c'est à dire que j'ai pas encore trouvé le chemin augmentant
                #donc j'ajoute v dans Q, c'est à dire qu'il est déja traité
                Q.append(v)
    #si je suis ici c'est à dire que j'ai pas trouvé un autre chemin augmentant de s à t
    #j'ai fini le traitement de tous les sommets donc je retourne None
    return None

def verifieCaP(Mcapacite, Mflot, u, v):
    return (Mcapacite[u][v]-Mflot[u][v]>0)

def recuperCapacite(edges, index):
    return edges[index][2]

def calculeGrapheResi(Edges_capacite, Edge_flow):
    EdgesResiduel = []
    for i in range (0, len(Edges_capacite)):
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
    SFlot = sum(MResiduel[sommets.index(source)][i] for i in xrange(length))
    return SFlot,liste_parcours,liste_flowMin


print("Exemple d'un Graphe vu sur wikipedia\n ")
#https://fr.wikipedia.org/wiki/Algorithme_d%27Edmonds-Karp

Edges_capacite = [['a', 'b', 3], ['a', 'd', 3], ['b', 'c', 4], ['c', 'd', 1], ['c', 'a', 3], ['c', 'e', 2], ['d', 'e', 2], ['d', 'f', 9], ['e', 'g', 1], ['e', 'b', 1], ['f', 'g', 9]]

g = DiGraph(Edges_capacite);
g.show(edge_labels = True)

Mcapacite = g.weighted_adjacency_matrix()
source = 'a'
puit = 'g'
fMax,liste_parcours,liste_flowMin= Edmonds_Karp( g, Mcapacite, source, puit)
print"Le Flot Maximum est ======> ", fMax,"\n"
print "Les Chemins Augmentants de la source : "+str(source)+" vers le puit : "+str(puit)+" sont les suivants : "

print("Chemin ======> Flot min de ce chemin \n")
for i in range(0, len(liste_parcours)-1) :
    print liste_parcours[i],"=====>",liste_flowMin[i]

print "---------------------------------------------------------- Les Tests --------------------------------------------------------------------"
print("\n\nLe Graphe demandé pour ce TP\n ")

Edges_capacite2 = [['s', 'a', 1], ['s', 'b', 7], ['s', 'c', 2], ['s', 'd', 5], ['s', 'e', 10], ['a', 'f',1], ['a', 'g', 2], ['b', 'g', 3], ['b', 'h', 5], ['c', 'h', 42], ['c', 'i', 17], ['d', 'i', 21], ['d', 'j', 2],['e', 'j', 27], ['e', 'f', 1], ['f', 'k', 2],['g', 'k', 1],['h', 'l', 2],['i', 'm', 1],['j', 'm', 2], ['k', 't', 4],['l', 't', 2],['l', 'k', 21], ['m', 't', 1],['m','l',21]]

g2 = DiGraph(Edges_capacite2);
g2.show(edge_labels = True)

Mcapacite2 = g2.weighted_adjacency_matrix()
source = 's'
puit = 't'
fMax,liste_parcours,liste_flowMin= Edmonds_Karp( g2, Mcapacite2, source, puit)
print"Le Flot Maximum est ======> ", fMax,"\n"
print "Les Chemins Augmentants de la source : "+str(source)+" vers le puit : "+str(puit)+" sont les suivants : "

print("Chemin ======> Flot min de ce chemin \n")
for i in range(len(liste_parcours)-1) :
    print liste_parcours[i],"=====>",liste_flowMin[i]




︡20da68e0-cab9-47f5-b689-a4ab876f1d97︡{"stdout":"Exemple d'un Graphe vu sur wikipedia\n \n"}︡{"file":{"filename":"/home/user/.sage/temp/project-39c1a38c-8fa4-4207-9503-ac5dc6033f9d/895/tmp_YS4uSj.svg","show":true,"text":null,"uuid":"0cb57be6-7cc4-4b2c-b0d5-884f22a66629"},"once":false}︡{"stdout":"Le Flot Maximum est ======>  5 \n\n"}︡{"stdout":"Les Chemins Augmentants de la source : a vers le puit : g sont les suivants : \n"}︡{"stdout":"Chemin ======> Flot min de ce chemin \n\n"}︡{"stdout":"[('a', 'd'), ('d', 'e'), ('e', 'g')] =====> 1\n[('a', 'd'), ('d', 'f'), ('f', 'g')] =====> 2\n[('a', 'b'), ('b', 'c'), ('c', 'd'), ('d', 'f'), ('f', 'g')] =====> 1\n[('a', 'b'), ('b', 'c'), ('c', 'e'), ('e', 'd'), ('d', 'f'), ('f', 'g')] =====> 1\n"}︡{"stdout":"---------------------------------------------------------- Les Tests --------------------------------------------------------------------\n"}︡{"stdout":"\n\nLe Graphe demandé pour ce TP\n \n"}︡{"file":{"filename":"/home/user/.sage/temp/project-39c1a38c-8fa4-4207-9503-ac5dc6033f9d/895/tmp_IFV4BM.svg","show":true,"text":null,"uuid":"b2ef75eb-422f-40df-a269-741f04de720b"},"once":false}︡{"stdout":"Le Flot Maximum est ======>  7 \n\n"}︡{"stdout":"Les Chemins Augmentants de la source : s vers le puit : t sont les suivants : \n"}︡{"stdout":"Chemin ======> Flot min de ce chemin \n\n"}︡{"stdout":"[('s', 'a'), ('a', 'f'), ('f', 'k'), ('k', 't')] =====> 1\n[('s', 'b'), ('b', 'g'), ('g', 'k'), ('k', 't')] =====> 1\n[('s', 'b'), ('b', 'h'), ('h', 'l'), ('l', 't')] =====> 2\n[('s', 'c'), ('c', 'i'), ('i', 'm'), ('m', 't')] =====> 1\n[('s', 'e'), ('e', 'f'), ('f', 'k'), ('k', 't')] =====> 1\n[('s', 'd'), ('d', 'j'), ('j', 'm'), ('m', 'l'), ('l', 'k'), ('k', 't')] =====> 1\n"}︡{"done":true}︡
︠bf55113b-ef4b-426b-859b-5994524b7d3f︠

︡3ad12f56-865b-4cde-86a8-259f07e1bf83︡{"done":true}︡
︠32082bdd-4728-4c43-ad8d-0ed047192808︠

︡132ab365-d3a6-4264-9894-c4663fef2158︡{"done":true}︡
︠8eca2913-adb3-47f7-b2d7-6632dd010082︠

︡8a69d966-c59e-4062-ba73-654a6c688842︡{"done":true}︡
︠3bce0259-b153-4414-9d90-9e7428dda837︠

︡3868025c-5b1c-4359-be66-c299d6fb782f︡{"done":true}︡
︠eec303b4-95de-4785-a62e-3d0b462448a7s︠

︡582eecdb-1b8a-4a0c-aa3b-c67f314f4cad︡{"done":true}︡
︠68e2594c-406c-4fb8-9747-93ed3cdce86cs︠

︡25ec43cd-780e-4d7a-ba32-6df5442ce08e︡{"done":true}︡
︠ea51ec6e-a3c3-4220-827e-8a527d9c8d97s︠

︡92f7fb1d-14a0-423c-8194-b0240900db16︡{"done":true}︡
︠723ff05a-850c-48ef-b0f6-84bba13a949fs︠

︡7b66bb39-4f02-410f-9e34-ac0947a6b3b6︡{"done":true}︡









