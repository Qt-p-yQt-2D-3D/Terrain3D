//==================================================================================================================|
// Created 2015.01.13 by Daniel L. Watkins
//
// Copyright (C) 2014-2015 Daniel L. Watkins
// This file is licensed under the MIT License.
//==================================================================================================================|

#ifndef _t3d_BASE_ENTITY_H
#define _t3d_BASE_ENTITY_H

#include <Library.h>

namespace t3d { namespace World { namespace Entity
{
	class BaseEntity : public QObject
	{
		Q_OBJECT
	public:
		class Id
		{
		public:
			Id(qint64 value) { mValue = value; }

			bool operator==(const Id &rhs) const
			{
				return mValue == rhs.mValue;
			}

		private:
			qint64 mValue;
		};

		BaseEntity(qint64 idValue) :
			mId(idValue)
		{
		}

		~BaseEntity() {}

		Id id() const { return mId; }
		Vec3f pos() const { return mPos; }

		class RenderComponent
		{
		public:
			void render(const Mat4 & cameraMatrix) {}
		};

		RenderComponent* cmp_renderable() const { return mCmp_renderable.get(); }
		void BaseEntity::createCmp_renderable()
		{
			if (!mCmp_renderable)
				mCmp_renderable = unique<RenderComponent>(new RenderComponent);
		}

	private:
		Id mId;
		Vec3f mPos;

		unique<RenderComponent> mCmp_renderable;
	};
}}}

#endif

