//==================================================================================================================|
// Created 2014.10.31 by Daniel L. Watkins
//
// Copyright (C) 2014 Daniel L. Watkins
// This file is licensed under the MIT License.
//==================================================================================================================|

#include "Utility.h"

namespace t3d { namespace World { namespace Terrain
{
	int maxLevelsOfDetail(int blockSize)
	{
		return int(std::log10(blockSize)/std::log10(2) + 0.5);
	}


	int sizeForLod(int lod)
	{
		return std::pow(2, lod+1);
	}


    double lodDistanceBetweenPos(Vec2i a, Vec2i b, int blockSize)
	{
        int baseBlockSize = 8;
		Vec2i net(a.x-b.x, a.y-b.y);

        return std::sqrt(net.x*net.x + net.y*net.y) * blockSize / baseBlockSize;
	}


	int lodForDistance(double distance)
	{
        if (distance > 16.0)
            return 2;
        else if (distance > 8.0)
            return 1;
        else
            return 0;
	}
}}}