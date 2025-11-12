# models.py
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()


class BusinessScene(db.Model):
    """业务场景表"""
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True, nullable=False)  # 场景名称
    description = db.Column(db.Text, nullable=False)  # 场景描述
    category = db.Column(db.String(50), nullable=False)  # 业务分类
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # 关联关系
    steps = db.relationship('SceneStep', backref='scene', lazy=True, cascade='all, delete-orphan')
    parameters = db.relationship('SceneParameter', backref='scene', lazy=True, cascade='all, delete-orphan')


class SceneStep(db.Model):
    """场景步骤表"""
    id = db.Column(db.Integer, primary_key=True)
    scene_id = db.Column(db.Integer, db.ForeignKey('business_scene.id'), nullable=False)
    step_number = db.Column(db.Integer, nullable=False)  # 步骤序号
    description = db.Column(db.Text, nullable=False)  # 步骤描述
    transaction_code = db.Column(db.String(20))  # 交易代码
    details = db.Column(db.Text)  # 详细说明
    condition = db.Column(db.String(100))  # 执行条件

    # 确保同一场景内步骤序号唯一
    __table_args__ = (db.UniqueConstraint('scene_id', 'step_number', name='unique_step_number_per_scene'),)


class SceneParameter(db.Model):
    """场景参数表"""
    id = db.Column(db.Integer, primary_key=True)
    scene_id = db.Column(db.Integer, db.ForeignKey('business_scene.id'), nullable=False)
    param_name = db.Column(db.String(50), nullable=False)  # 参数名称
    param_type = db.Column(db.String(20), nullable=False)  # 参数类型: amount, relationship, currency
    required = db.Column(db.Boolean, default=True)  # 是否必需
    default_value = db.Column(db.String(100))  # 默认值


class User(db.Model):
    """用户表"""
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(120), nullable=False)
    role = db.Column(db.String(20), default='user')  # user, admin
    created_at = db.Column(db.DateTime, default=datetime.utcnow)