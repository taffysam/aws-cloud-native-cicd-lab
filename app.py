from fastapi import FastAPI, Query

app = FastAPI(
    title="Shipping Calculator API",
    version="1.0.0"
)


def calculate_shipping(weight, express=False):
    if weight <= 5:
        cost = 50
    elif weight <= 10:
        cost = 100
    else:
        cost = 150

    if express:
        cost += 75

    return cost


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.get("/shipping")
def shipping(
    weight: float = Query(..., gt=0),
    express: bool = False
):
    cost = calculate_shipping(weight, express)

    return {
        "weight": weight,
        "express": express,
        "shipping_cost": cost
    }

