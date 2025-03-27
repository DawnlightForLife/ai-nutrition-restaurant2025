import React, { useState, useEffect } from 'react';
import { nutritionProfileApi } from '../services/api';
import { useAuth } from '../contexts/AuthContext';
import {
    Box,
    Card,
    CardContent,
    Typography,
    Button,
    TextField,
    Grid,
    Select,
    MenuItem,
    FormControl,
    InputLabel,
    Chip,
    Alert,
    CircularProgress
} from '@mui/material';

const NutritionProfile = () => {
    const { user } = useAuth();
    const [profiles, setProfiles] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [editingProfile, setEditingProfile] = useState(null);
    const [formData, setFormData] = useState({
        name: '',
        gender: 'other',
        age: '',
        height: '',
        weight: '',
        activity_level: 'moderate',
        health_conditions: [],
        dietary_preferences: {
            cuisine_preference: 'other',
            allergies: [],
            avoided_ingredients: [],
            spicy_preference: 'medium',
            diet_type: 'omnivore'
        },
        goals: 'health_improvement',
        nutrition_targets: {
            calories: '',
            protein_percentage: '',
            carbs_percentage: '',
            fat_percentage: ''
        }
    });

    useEffect(() => {
        loadProfiles();
    }, [user]);

    const loadProfiles = async () => {
        try {
            setLoading(true);
            const response = await nutritionProfileApi.getUserProfiles(user.id);
            setProfiles(response.profiles);
            setError(null);
        } catch (err) {
            setError('加载营养档案失败');
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (editingProfile) {
                await nutritionProfileApi.updateProfile(editingProfile._id, formData);
            } else {
                await nutritionProfileApi.createProfile(formData);
            }
            await loadProfiles();
            setEditingProfile(null);
            setFormData({
                name: '',
                gender: 'other',
                age: '',
                height: '',
                weight: '',
                activity_level: 'moderate',
                health_conditions: [],
                dietary_preferences: {
                    cuisine_preference: 'other',
                    allergies: [],
                    avoided_ingredients: [],
                    spicy_preference: 'medium',
                    diet_type: 'omnivore'
                },
                goals: 'health_improvement',
                nutrition_targets: {
                    calories: '',
                    protein_percentage: '',
                    carbs_percentage: '',
                    fat_percentage: ''
                }
            });
        } catch (err) {
            setError('保存营养档案失败');
            console.error(err);
        }
    };

    const handleEdit = (profile) => {
        setEditingProfile(profile);
        setFormData(profile);
    };

    const handleDelete = async (profileId) => {
        if (window.confirm('确定要删除这个营养档案吗？')) {
            try {
                await nutritionProfileApi.deleteProfile(profileId);
                await loadProfiles();
            } catch (err) {
                setError('删除营养档案失败');
                console.error(err);
            }
        }
    };

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
                <CircularProgress />
            </Box>
        );
    }

    return (
        <Box>
            {error && (
                <Alert severity="error" sx={{ mb: 2 }}>
                    {error}
                </Alert>
            )}

            <Card sx={{ mb: 4 }}>
                <CardContent>
                    <Typography variant="h6" gutterBottom>
                        {editingProfile ? '编辑营养档案' : '创建新营养档案'}
                    </Typography>
                    <form onSubmit={handleSubmit}>
                        <Grid container spacing={2}>
                            <Grid item xs={12} md={6}>
                                <TextField
                                    fullWidth
                                    label="档案名称"
                                    value={formData.name}
                                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                                    required
                                />
                            </Grid>
                            <Grid item xs={12} md={6}>
                                <FormControl fullWidth>
                                    <InputLabel>性别</InputLabel>
                                    <Select
                                        value={formData.gender}
                                        onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
                                        label="性别"
                                    >
                                        <MenuItem value="male">男</MenuItem>
                                        <MenuItem value="female">女</MenuItem>
                                        <MenuItem value="other">其他</MenuItem>
                                    </Select>
                                </FormControl>
                            </Grid>
                            <Grid item xs={12} md={4}>
                                <TextField
                                    fullWidth
                                    label="年龄"
                                    type="number"
                                    value={formData.age}
                                    onChange={(e) => setFormData({ ...formData, age: e.target.value })}
                                />
                            </Grid>
                            <Grid item xs={12} md={4}>
                                <TextField
                                    fullWidth
                                    label="身高 (cm)"
                                    type="number"
                                    value={formData.height}
                                    onChange={(e) => setFormData({ ...formData, height: e.target.value })}
                                />
                            </Grid>
                            <Grid item xs={12} md={4}>
                                <TextField
                                    fullWidth
                                    label="体重 (kg)"
                                    type="number"
                                    value={formData.weight}
                                    onChange={(e) => setFormData({ ...formData, weight: e.target.value })}
                                />
                            </Grid>
                            <Grid item xs={12}>
                                <FormControl fullWidth>
                                    <InputLabel>活动水平</InputLabel>
                                    <Select
                                        value={formData.activity_level}
                                        onChange={(e) => setFormData({ ...formData, activity_level: e.target.value })}
                                        label="活动水平"
                                    >
                                        <MenuItem value="sedentary">久坐不动</MenuItem>
                                        <MenuItem value="light">轻度活动</MenuItem>
                                        <MenuItem value="moderate">中度活动</MenuItem>
                                        <MenuItem value="active">活跃</MenuItem>
                                        <MenuItem value="very_active">非常活跃</MenuItem>
                                    </Select>
                                </FormControl>
                            </Grid>
                            <Grid item xs={12}>
                                <FormControl fullWidth>
                                    <InputLabel>饮食目标</InputLabel>
                                    <Select
                                        value={formData.goals}
                                        onChange={(e) => setFormData({ ...formData, goals: e.target.value })}
                                        label="饮食目标"
                                    >
                                        <MenuItem value="weight_loss">减重</MenuItem>
                                        <MenuItem value="weight_gain">增重</MenuItem>
                                        <MenuItem value="maintenance">维持体重</MenuItem>
                                        <MenuItem value="muscle_gain">增肌</MenuItem>
                                        <MenuItem value="health_improvement">改善健康</MenuItem>
                                    </Select>
                                </FormControl>
                            </Grid>
                            <Grid item xs={12}>
                                <Box display="flex" gap={2}>
                                    <Button
                                        type="submit"
                                        variant="contained"
                                        color="primary"
                                        fullWidth
                                    >
                                        {editingProfile ? '保存更改' : '创建档案'}
                                    </Button>
                                    {editingProfile && (
                                        <Button
                                            variant="outlined"
                                            color="secondary"
                                            onClick={() => {
                                                setEditingProfile(null);
                                                setFormData({
                                                    name: '',
                                                    gender: 'other',
                                                    age: '',
                                                    height: '',
                                                    weight: '',
                                                    activity_level: 'moderate',
                                                    health_conditions: [],
                                                    dietary_preferences: {
                                                        cuisine_preference: 'other',
                                                        allergies: [],
                                                        avoided_ingredients: [],
                                                        spicy_preference: 'medium',
                                                        diet_type: 'omnivore'
                                                    },
                                                    goals: 'health_improvement',
                                                    nutrition_targets: {
                                                        calories: '',
                                                        protein_percentage: '',
                                                        carbs_percentage: '',
                                                        fat_percentage: ''
                                                    }
                                                });
                                            }}
                                        >
                                            取消编辑
                                        </Button>
                                    )}
                                </Box>
                            </Grid>
                        </Grid>
                    </form>
                </CardContent>
            </Card>

            <Typography variant="h6" gutterBottom>
                我的营养档案
            </Typography>
            <Grid container spacing={2}>
                {profiles.map((profile) => (
                    <Grid item xs={12} md={6} key={profile._id}>
                        <Card>
                            <CardContent>
                                <Typography variant="h6">{profile.name}</Typography>
                                <Typography color="textSecondary" gutterBottom>
                                    性别: {profile.gender === 'male' ? '男' : profile.gender === 'female' ? '女' : '其他'}
                                </Typography>
                                <Typography color="textSecondary" gutterBottom>
                                    年龄: {profile.age}
                                </Typography>
                                <Typography color="textSecondary" gutterBottom>
                                    身高: {profile.height}cm
                                </Typography>
                                <Typography color="textSecondary" gutterBottom>
                                    体重: {profile.weight}kg
                                </Typography>
                                <Typography color="textSecondary" gutterBottom>
                                    活动水平: {
                                        {
                                            sedentary: '久坐不动',
                                            light: '轻度活动',
                                            moderate: '中度活动',
                                            active: '活跃',
                                            very_active: '非常活跃'
                                        }[profile.activity_level]
                                    }
                                </Typography>
                                <Typography color="textSecondary" gutterBottom>
                                    目标: {
                                        {
                                            weight_loss: '减重',
                                            weight_gain: '增重',
                                            maintenance: '维持体重',
                                            muscle_gain: '增肌',
                                            health_improvement: '改善健康'
                                        }[profile.goals]
                                    }
                                </Typography>
                                <Box mt={2} display="flex" gap={1}>
                                    <Button
                                        variant="outlined"
                                        size="small"
                                        onClick={() => handleEdit(profile)}
                                    >
                                        编辑
                                    </Button>
                                    <Button
                                        variant="outlined"
                                        color="error"
                                        size="small"
                                        onClick={() => handleDelete(profile._id)}
                                    >
                                        删除
                                    </Button>
                                </Box>
                            </CardContent>
                        </Card>
                    </Grid>
                ))}
            </Grid>
        </Box>
    );
};

export default NutritionProfile; 