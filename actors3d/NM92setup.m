world = sim3d.World();

NM92.FoundationPile = sim3d.Actor(ActorName='FoundationPile',...
    Translation=[0 0 0],...
    Mobility=sim3d.utils.MobilityTypes.Static);
add(world,NM92.FoundationPile);
load(NM92.FoundationPile,'NM92_FoundationPile.x3d')

NM92.DeckSupportPlate1 = sim3d.Actor(ActorName='DeckSupportPlate1',...
    Mobility=sim3d.utils.MobilityTypes.Static);
add(world,NM92.DeckSupportPlate1);
load(NM92.DeckSupportPlate1,'NM92_DeckSupportPlate1.x3d')

NM92.DeckSupportPlate2 = sim3d.Actor(ActorName='DeckSupportPlate2',...
    Mobility=sim3d.utils.MobilityTypes.Static);
add(world,NM92.DeckSupportPlate2);
load(NM92.DeckSupportPlate2,'NM92_DeckSupportPlate2.x3d')

NM92.DeckSupport1 = sim3d.Actor(ActorName='DeckSupport1',...
    Mobility=sim3d.utils.MobilityTypes.Static);
add(world,NM92.DeckSupport1);
load(NM92.DeckSupport1,'NM92_DeckSupport1.x3d')

NM92.DeckSupport2 = sim3d.Actor(ActorName='DeckSupport2',...
    Mobility=sim3d.utils.MobilityTypes.Static);
add(world,NM92.DeckSupport2);
load(NM92.DeckSupport2,'NM92_DeckSupport2.x3d')

NM92.Deck = sim3d.Actor(ActorName='Deck',...
    Mobility=sim3d.utils.MobilityTypes.Static);
add(world,NM92.Deck);
load(NM92.Deck,'NM92_Deck.x3d')

NM92.DeckRailing = sim3d.Actor(ActorName='DeckRailing',...
    Mobility=sim3d.utils.MobilityTypes.Static);
add(world,NM92.DeckRailing);
load(NM92.DeckRailing,'NM92_DeckRailing.x3d')

NM92.ForeAftJoint = sim3d.Actor(ActorName='ForeAftJoint',...
    Translation=[0 0 14],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.ForeAftJoint,NM92.FoundationPile)

NM92.Tower = sim3d.Actor(ActorName='Tower',...
    Translation=[0 0 -14],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.Tower,NM92.ForeAftJoint);
load(NM92.Tower,'NM92_Tower.x3d')

NM92.Door = sim3d.Actor(ActorName='Door',...
    Translation=[0 0 -14],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.Door,NM92.ForeAftJoint);
load(NM92.Door,'NM92_Door.x3d')

NM92.YawJoint = sim3d.Actor(ActorName='YawJoint',...
    Translation=[0 0 68],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.YawJoint,NM92.Tower)

NM92.NacelleSpoiler = sim3d.Actor(ActorName='NacelleSpoiler',...
    Translation=[0 0 -68],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.NacelleSpoiler,NM92.YawJoint);
load(NM92.NacelleSpoiler,'NM92_NacelleSpoiler.x3d')

NM92.NacelleSpoilerMesh = sim3d.Actor(ActorName='NacelleSpoilerMesh',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.NacelleSpoilerMesh,NM92.NacelleSpoiler);
load(NM92.NacelleSpoilerMesh,'NM92_NacelleSpoilerMesh.x3d')

NM92.NacelleSides = sim3d.Actor(ActorName='NacelleSides',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.NacelleSides,NM92.NacelleSpoiler);
load(NM92.NacelleSides,'NM92_NacelleSides.x3d')

NM92.HubConnect = sim3d.Actor(ActorName='HubConnect',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.HubConnect,NM92.NacelleSpoiler);
load(NM92.HubConnect,'NM92_HubConnect.x3d')

NM92.RotationAxis = sim3d.Actor(ActorName='RotationAxis',...
    Translation=[-0.039169 2.146902 69.95571],...
    Rotation=[-0.0698124 0 0],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.RotationAxis,NM92.HubConnect)

NM92.RotationJoint = sim3d.Actor(ActorName='RotationJoint',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.RotationJoint,NM92.RotationAxis)

NM92.RotationInverse = sim3d.Actor(ActorName='RotationInverse',...
    Rotation=[0.0698124 0 0],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.RotationInverse,NM92.RotationJoint)

NM92.Hub = sim3d.Actor(ActorName='Hub',...
    Translation=[0.039169 -2.146902 -69.95571],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.Hub,NM92.RotationInverse);
load(NM92.Hub,'NM92_Hub.x3d')
 
NM92.HubHatch1 = sim3d.Actor(ActorName='HubHatch1',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.HubHatch1,NM92.Hub);
load(NM92.HubHatch1,'NM92_HubHatch1.x3d')

NM92.HubHatch2 = sim3d.Actor(ActorName='HubHatch2',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.HubHatch2,NM92.Hub);
load(NM92.HubHatch2,'NM92_HubHatch2.x3d')

NM92.HubHatch3 = sim3d.Actor(ActorName='HubHatch3',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.HubHatch3,NM92.Hub);
load(NM92.HubHatch3,'NM92_HubHatch3.x3d')

NM92.RotorAxis = sim3d.Actor(ActorName='RotorAxis',...
    Translation=[-0.035752 3.576152 70.059258],...
    Rotation=[-0.0698124 0 0],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.RotorAxis,NM92.Hub)

NM92.BladeAxis1= sim3d.Actor(ActorName='BladeAxis1',...
    Rotation=[0 -pi*2/3 0],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeAxis1,NM92.RotorAxis)

NM92.BladeJoint1= sim3d.Actor(ActorName='BladeJoint1',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeJoint1,NM92.BladeAxis1)

NM92.BladeInverse1 = sim3d.Actor(ActorName='BladeInverse1',...
    Rotation=[0.0698124 pi*2/3 pi],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeInverse1,NM92.BladeJoint1)

NM92.Blade1 = sim3d.Actor(ActorName='Blade1',...
    Translation=[0.035752 -3.576152 -70.059258],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.Blade1,NM92.BladeInverse1);
load(NM92.Blade1,'NM92_Blade1.x3d')

NM92.BladeAxis2= sim3d.Actor(ActorName='BladeAxis2',...
    Rotation=[0 pi*2/3 0],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeAxis2,NM92.RotorAxis)

NM92.BladeJoint2= sim3d.Actor(ActorName='BladeJoint2',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeJoint2,NM92.BladeAxis2)

NM92.BladeInverse2 = sim3d.Actor(ActorName='BladeInverse2',...
    Rotation=[0.0698124 -pi*2/3 pi],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeInverse2,NM92.BladeJoint2)

NM92.Blade2 = sim3d.Actor(ActorName='Blade2',...
    Translation=[0.035752 -3.576152 -70.059258],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.Blade2,NM92.BladeInverse2);
load(NM92.Blade2,'NM92_Blade2.x3d')

NM92.BladeAxis3= sim3d.Actor(ActorName='BladeAxis3',...
    Rotation=[0 0 0],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeAxis3,NM92.RotorAxis)

NM92.BladeJoint3= sim3d.Actor(ActorName='BladeJoint3',...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeJoint3,NM92.BladeAxis3)

NM92.BladeInverse3 = sim3d.Actor(ActorName='BladeInverse3',...
    Rotation=[0.0698124 0 pi],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.BladeInverse3,NM92.BladeJoint3)

NM92.Blade3 = sim3d.Actor(ActorName='Blade3',...
    Translation=[0.035752 -3.576152 -70.059258],...
    Mobility=sim3d.utils.MobilityTypes.Movable);
add(world,NM92.Blade3,NM92.BladeInverse3);
load(NM92.Blade3,'NM92_Blade3.x3d')



NM92.ForeAftJoint.Rotation = [0 0 0];
NM92.TiltJoint.AngularVelocity = [0 0 0];
NM92.RotationJoint.AngularVelocity = [0 0.1 0];

world.Viewpoints.Default.Translation = [0 120 60];
world.Viewpoints.Default.Rotation = [0 0 -pi/2];
% 
NM92.BladeJoint1.AngularVelocity = [0 0 0.1];
NM92.BladeJoint2.AngularVelocity = [0 0 0.1];
NM92.BladeJoint3.AngularVelocity = [0 0 0.1];

sampletime = 0.1;
stoptime = 10000;
run(world,sampletime,stoptime);

view(world)

