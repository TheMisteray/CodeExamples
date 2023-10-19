﻿using Microsoft.Xna.Framework;
using Terraria;
using Terraria.DataStructures;
using Terraria.ModLoader;

namespace ExoriumMod.Content.Gores.Trees
{
    class DeadwoodTreeFX : ModGore
    {
        public override void OnSpawn(Gore gore, IEntitySource source)
        {
            gore.velocity = new Vector2(Main.rand.NextFloat() - 0.5f, Main.rand.NextFloat() * MathHelper.TwoPi);
            gore.numFrames = 8;
            gore.frame = (byte)Main.rand.Next(8);
            gore.frameCounter = (byte)Main.rand.Next(8);
            UpdateType = 910;
        }
    }
}
